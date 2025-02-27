from ..dependencies import get_db
from ..services.database import Database
from ..services import mini_scarper
from ..schema import UserLogin
from .auth import get_current_active_user
from fastapi import Depends, Response, status, APIRouter, HTTPException
from typing import Annotated
from decimal import Decimal

router = APIRouter(prefix='/portfolio', tags=["Portfolio",])


@router.get("/")
async def get_portfolio(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch("SELECT * FROM get_portfolio_summary(($1))", current_user.id)
    return results


@router.get("/summary")
async def get_summary_external(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch(
        "SELECT * FROM get_portfolio_summary(($1))", 
        current_user.id)
    tickers = [item['ticker'] for item in results if item['ticker'] != 'Money']
    
    # Get current prices for the tickers
    stocks = mini_scarper.get_current_price_tickers(tickers)
    
    # Build a dictionary mapping ticker to price (only include those with a valid price)
    price_map = {stock['ticker']: stock['price'] for stock in stocks if stock['price'] is not None}
    
    clean_result = []
    
    for row in results:
        ticker = row.get('ticker')
        # Skip if ticker is 'Money' or missing from our price_map
        if ticker and ticker in price_map:
            # Ensure that totalQuantity is valid and convert to Decimal if necessary
            quantity = row.get('totalQuantity')
            if quantity is not None:
                try:
                    # Calculate market value: price * quantity
                    row["marketValue"] = Decimal(price_map[ticker]) * Decimal(quantity)
                    clean_result.append(row)
                except Exception as e:
                    print(f"Error calculating market value for ticker {ticker}: {e}")
            else:
                print(f"No totalQuantity for ticker {ticker}")
        else:
            if ticker not in price_map:
                print(f"Price not found for ticker {ticker} (or price is None).")
    return clean_result


@router.get("/summary/{ticker}")
async def get_portfolio_ticker_aggregate(
        ticker:str,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetchrow(
        """SELECT 
                sum(totalvalue) as "totalValue",
                sum(quantity) as "totalQuantity",
                MIN(price) as "minPrice", 
                MAX(price) as "maxPrice",
                sum(totalvalue)/sum(quantity) as breakeven 
                FROM portfolio 
            where user_id = ($1)
            AND ticker =($2);
        ;""", current_user.id, ticker)
    return results

@router.get("/funds")
async def get_total_funds(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db),
        limit: int = 10):
    results = await db.fetch("SELECT * FROM funds WHERE user_id = ($1) ORDER BY created_at DESC LIMIT ($2)", current_user.id, limit)
    return results


@router.get("/allocation")
async def get_allocation_funds(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch("""
                            with cte as (
                                SELECT ticker,
                                SUM(quantity) AS quantity 
                                FROM portfolio 
                                WHERE user_id = ($1)
                                GROUP BY ticker
                            )
                            SELECT 
                            c.ticker,
                            c.quantity,
                            m.sector,
                            m.industry
                            FROM metadata m
                            JOIN cte c
                            ON c.ticker = m.ticker;
                            """, current_user.id)
    return results


@router.get("/allocation/inital_cost")
async def get_portfolio_barchart_data(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch(
        """SELECT ticker, SUM(totalValue) AS "totalValue" 
            FROM portfolio
            WHERE user_id = ($1)
            GROUP BY ticker;""", 
        current_user.id)
    return results


@router.get("/funds/totals")
async def get_total_funds(current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
    results = await db.fetchrow("SELECT * FROM calculate_portfolio_totals(($1))", current_user.id)
    return results


@router.post("/funds/add")
async def add_funds(amount: int,
                    current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
    print(amount)
    results = await db.fetch("INSERT INTO funds(user_id, amount, description) VALUES (($1), ($2), 'Deposit')", current_user.id, amount)
    return results


@router.post("/funds/withdraw")
async def add_funds(amount: int,
                    current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
    portfolio = await db.fetchrow("SELECT * FROM calculate_portfolio_totals(($1))", current_user.id)
    if portfolio:
        if amount > portfolio["total_funds"]:
            print('Not enough funds')
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                                detail="Not enough funds")
    results = await db.fetch("INSERT INTO funds(user_id, amount, description) VALUES (($1), ($2), 'Withraw')", current_user.id, -amount)
    return results
