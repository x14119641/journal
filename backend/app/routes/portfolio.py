from ..dependencies import get_db
from ..services.database import Database
from ..services import mini_scarper
from ..schema import UserLogin
from .auth import get_current_active_user
from fastapi import Depends, Response, status, APIRouter, HTTPException
from typing import Annotated
from decimal import Decimal

router = APIRouter(prefix='/portfolio', tags=["Portfolio",])


@router.get("/get_balance")
async def get_balance(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    current_balance = await db.fetchone("SELECT get_balance(($1))", current_user.id)
    return {'value': current_balance}

@router.get("/get_portfolio")
async def get_portfolio(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch("SELECT * FROM get_portfolio(($1))", current_user.id)

    if not results: 
        raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
                            detail="Portfolio is empty")

    return results


@router.get("/get_total_fees")
async def get_total_fees(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetchone("SELECT * FROM get_total_fees(($1))", current_user.id)
    # print(results)
    # if not results:
    #     raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
    #                             detail="Noo fees")
    return {"value": results}


@router.get("/get_total_money_invested")
async def get_total_money_invested(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    money_invested = await db.fetchone("SELECT get_total_money_invested(($1))", 
                                        current_user.id)
    # print(money_invested)
    return {"value": money_invested}


@router.get("/get_total_money_earned")
async def get_total_money_invested(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    earnings_from_selling = await db.fetchone("SELECT get_total_money_earned(($1))", 
                                        current_user.id)
    # print(earnings_from_selling)
    return {"value": earnings_from_selling}


@router.get("/get_current_portfolio_value")
async def get_current_portfolio_value(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    current_portfolio_value = await db.fetchone("SELECT get_current_portfolio_value(($1))", 
                                        current_user.id)
    # print(current_portfolio_value)
    return {"value": current_portfolio_value}


@router.get("/get_net_profit_loss")
async def get_net_profit_loss(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    net_profit_loss = await db.fetchone("SELECT get_net_profit_loss(($1))", 
                                        current_user.id)
    print(net_profit_loss)
    return {"value": net_profit_loss}

@router.get("/ticker/{ticker}")
async def get_ticker_portfolio_summary(
        ticker: str,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetchrow("SELECT * FROM get_ticker_portfolio_summary($1, $2)", 
                             current_user.id, ticker)

    if not results: 
        raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
                            detail="Ticker not in Portfolio")

    return results


@router.get("/get_monthly_performance/{month}/{year}")
async def get_monthly_performance(
        month: int, year: int,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetchrow("""
                             SELECT * FROM get_monthly_performance(($1), ($2), ($3))""", 
                             current_user.id, month, year)

    return results


@router.get("/get_unrealized_money")
async def get_unrealized_money(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    net_profit_loss = await db.fetchone("SELECT get_unrealized_money(($1))", 
                                        current_user.id)
    print(net_profit_loss)
    return {"value": net_profit_loss}


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



@router.get("/allocation/sector")
async def get_allocation_funds(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch("""
                            with cte as (
                                SELECT ticker,
                                SUM(remaining_qunatity) AS quantity 
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


# @router.get("/allocation/inital_cost")
# async def get_portfolio_barchart_data(
#         current_user: Annotated[UserLogin, Depends(get_current_active_user)],
#         db: Database = Depends(get_db)):
#     results = await db.fetch(
#         """SELECT ticker, SUM(total_value) AS "totalValue" 
#             FROM portfolio
#             WHERE user_id = ($1)
#             GROUP BY ticker;""", 
#         current_user.id)
#     return results


# @router.get("/funds/totals")
# async def get_total_funds(current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
#     """HEre we are supposed to get the following values:
#     total_funds: avalaible funds to invest. I guess i will change the name too
#     total_spent: amount invested right now (not as market), I guess i will change that too
#     total_gains: realized gains (i think i will change the name)
#     """
#     results = await db.fetchrow("""
#                                 SELECT * FROM calculate_portfolio_totals(($1))""", 
#                                 current_user.id)
#     return results


# @router.post("/funds/add", status_code=status.HTTP_201_CREATED)
# async def add_funds(amount: int,
#                     current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
#     # print(amount)
#     results = await db.fetchrow("""
#                              INSERT INTO funds(user_id, amount, description) 
#                              VALUES (($1), ($2), 'Deposit') RETURNING * """, current_user.id, amount)
#     print('RESULTS money: ', results)
#     return results


# @router.post("/funds/withdraw", status_code=status.HTTP_201_CREATED)
# async def withdraw_funds(amount: int,
#                     current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
#     portfolio = await db.fetchrow(
#         "SELECT * FROM calculate_portfolio_totals(($1))", current_user.id)
#     if portfolio:
#         if amount > portfolio["total_funds"]:
#             print('Not enough funds')
#             raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
#                                 detail="Not enough funds")
#     results = await db.fetchrow("""INSERT INTO funds(user_id, amount, description) 
#                              VALUES (($1), ($2), 'Withdraw') RETURNING *""", 
#                              current_user.id, -amount)
#     return results
