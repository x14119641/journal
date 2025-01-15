from typing import List, Annotated
from ..dependencies import get_db, last_day_of_month
from ..services.database import Database
from ..config import Settings
from fastapi import Depends, Response, status, HTTPException, APIRouter
from .auth import get_current_active_user
from ..schema import (UserResponse, UserLogin, Post,
                      PostBase, PostCreate, PostOut)
from datetime import datetime

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
