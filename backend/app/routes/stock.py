from typing import List, Annotated, Optional
from ..dependencies import get_db, last_day_of_month
from ..services.database import Database
from ..config import Settings
from fastapi import Depends, Response, status, HTTPException, APIRouter
from .auth import get_current_active_user
from ..schema import (UserResponse, UserLogin, Post,
                      PostBase, PostCreate, PostOut)
from datetime import datetime
from decimal import Decimal
router = APIRouter(prefix='/stocks', tags=["Stocks"])


@router.get("/tickers")
async def get_tickers(db: Database = Depends(get_db)):
    results = await db.fetch("SELECT * FROM tickers;")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not tickers")
    return results


@router.get("/dividends")
async def get_dividends(db: Database = Depends(get_db)):
    results = await db.fetch("SELECT * FROM dividends WHERE ex_dividend_date IS NOT NULL AND declaration_date IS NOT NULL ORDER BY ex_dividend_date DESC LIMIT 100")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return results


@router.get("/dividends/myfavorites")
async def get_favorites(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    results = await db.fetch("""
                            SELECT f.ticker FROM tickers t 
                            INNER JOIN favorites f
                            ON t.ticker = f.ticker
                            INNER JOIN users u
                            ON f.user_id = u.id
                            WHERE u.id = ($1) """, current_user.id)
    print('results: ', results)
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return results


@router.delete("/dividends/myfavorites/remove")
async def remove_favorites(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):

    await db.execute("""
                            DELETE FROM favorites 
                            WHERE user_id = ($1) 
                            AND ticker = ($2)""", current_user.id, ticker)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post("/dividends/myfavorites/add")
async def add_favorites(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    results = await db.fetch("""
                            INSERT INTO favorites(ticker, user_id) VALUES ($1,$2) RETURNING 1""", ticker, current_user.id)
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return Response(status_code=status.HTTP_201_CREATED)


@router.get("/dividends/{ticker}")
async def get_dividends_by_ticker(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    results = await db.fetch("SELECT * FROM dividends WHERE ticker = ($1) ORDER BY ex_dividend_date DESC", ticker.upper())
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return results


@router.get("/dividends/calendar/{month}")
async def get_dividends_calendar(
    month: int,
    db: Database = Depends(get_db)
):
    start_month = datetime(day=1, month=month, year=datetime.today().year)
    end_month = last_day_of_month(start_month)
    results = await db.fetch("""
                            SELECT d.ticker, d.amount, d.payment_date FROM dividends d
                            WHERE d.payment_date BETWEEN ($1) AND ($2);
                             """, start_month, end_month)
    return  results




# stocks/screener
@router.get("/screener")
async def get_stock_by_ticker(
    paymentMonth: int,
    institutionalPercentage: Optional[Decimal] = None,
    amountAbove: Optional[Decimal] = None,
    ratioholdersbuysold:Optional[Decimal] = None,
    db: Database = Depends(get_db)
):
    query = """
        SELECT 
            d.ticker,
            d.ex_dividend_date, 
            d.payment_date, 
            d.amount,
            i.institutional_ownership_perc, 
            i.increased_positions_holders, 
            i.decreased_positions_holders, 
            i.held_positions_holders,
            i.total_institutional_holders, 
            i.new_positions_holders, 
            i.sold_out_positions_holders,
            NULLIF(i.new_positions_holders, 0) / NULLIF(i.sold_out_positions_holders, 0) AS ratioHoldersBuySold
        FROM 
            dividends d
        INNER JOIN 
            institutional_holdings i
        ON 
            d.ticker = i.ticker
        WHERE 
            EXTRACT(YEAR FROM d.payment_date) = 2025 
            AND EXTRACT(MONTH FROM d.payment_date) = $1
    """
    
    query_params = [paymentMonth]
    param_counter = 2  # Start from $2 for dynamic parameters

    if amountAbove is not None:
        query += f" AND d.amount >= ${param_counter}"
        query_params.append(amountAbove)
        param_counter += 1

    if institutionalPercentage is not None:
        query += f" AND i.institutional_ownership_perc >= ${param_counter}"
        query_params.append(institutionalPercentage)
        param_counter += 1

    if ratioholdersbuysold is not None:
        query += f" AND NULLIF(i.new_positions_holders, 0) / NULLIF(i.sold_out_positions_holders, 0) >= ${param_counter}"
        query_params.append(ratioholdersbuysold)

    results = await db.fetch(query, *query_params)
    
    return results





@router.get("/{ticker}")
async def get_stock_by_ticker(
    ticker: str,
    db: Database = Depends(get_db)
):
    query = """
        SELECT m.ticker, m.name, m.market_cap, m.country, m.sector, m.industry,
            i.institutional_ownership_perc, i.increased_positions_holders, i.decreased_positions_holders, i.held_positions_holders,
            i.total_institutional_holders, i.new_positions_holders, i.sold_out_positions_holders
        FROM metadata m
        INNER JOIN institutional_holdings i
        ON m.ticker = i.ticker
        WHERE m.ticker=$1;
    """
    results = await db.fetch(query, ticker.upper())
    if not results:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Stock not found.")
    return results



# # stocks/"MAIN"
# @router.get("/{ticker}")
# async def get_stock_by_ticker(
#     ticker: str,
#     db: Database = Depends(get_db)
# ):
#     query = """
#         SELECT m.ticker, m.name, m.market_cap, m.country, m.sector, m.industry,
#             i.institutional_ownership_perc, i.increased_positions_holders, i.decreased_positions_holders, i.held_positions_holders,
#             i.total_institutional_holders, i.new_positions_holders, i.sold_out_positions_holders
#         FROM metadata m
#         INNER JOIN institutional_holdings i
#         ON m.ticker = i.ticker
#         WHERE m.ticker=($1);
#     """
#     print("Getting ticket data from: ",ticker)
#     # results = await db.fetch(query, ticker)
#     results = {
#         "ticker": "MAIN",
#         "name" : "MAin insustries",
#         "country": "EEUU",
#         "sector": "Finances",
#         "industry": "Services",
#         "institutional_ownership_perc": 40.3,
#         "increased_positions_holders": 20,
#         "decreased_positions_holders":5,
#         "held_positions_holders": 10,
#         "total_institutional_holders": 50,
#         "new_positions_holders":1,
#         "sold_out_positions_holders":0
#     }
#     return  results