from fastapi import Depends, Response, status, HTTPException, APIRouter
from.auth import get_current_active_user
from ..config import Settings
from ..services.database import Database
from ..schema import (UserResponse, UserLogin,Post, PostBase, PostCreate, PostOut)
from ..dependencies import get_db, oauth2_scheme, password_hash
from typing import List, Annotated


router = APIRouter(prefix='/stocks', tags=["Stocks"])


@router.get("/tickers")
async def get_tickers(db:Database=Depends(get_db)):
    results = await db.fetch("SELECT * FROM tickers;")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not tickers")
    return  results



@router.get("/dividends")
async def get_dividends(db:Database=Depends(get_db)):
    results = await db.fetch("SELECT * FROM dividends ORDER BY id DESC LIMIT 100")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return  results


@router.get("/dividends/{ticker}")
async def get_dividends_by_ticker(ticker:str,db:Database=Depends(get_db)):
    results = await db.fetch("SELECT * FROM dividends WHERE ticker = ($1) ORDER BY ex_dividend_date DESC", ticker)
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return  results