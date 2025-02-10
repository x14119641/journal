from ..dependencies import get_db
from ..services.database import Database
from ..schema import UserLogin
from .auth import get_current_active_user
from fastapi import Depends, Response, status, APIRouter, HTTPException
from typing import Annotated
router = APIRouter(prefix='/portfolio', tags=["Portfolio",])


@router.get("/")
async def get_portfolio(current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    results = await db.fetch("SELECT ticker FROM portfolio WHERE id = ($1)", current_user.id)
    return results  


@router.get("/funds")
async def get_total_funds(
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],
    db:Database=Depends(get_db),
    limit:int=10):
    results = await db.fetch("SELECT * FROM funds WHERE user_id = ($1) ORDER BY created_at DESC LIMIT ($2)", current_user.id, limit)
    print(results)
    return results  


@router.get("/funds/totals")
async def get_total_funds(current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    results = await db.fetchrow("SELECT * FROM calculate_portfolio_totals(($1))", current_user.id)
    return results  


@router.post("/funds/add")
async def add_funds(amount:int,
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    print(amount)
    results = await db.fetch("INSERT INTO funds(user_id, amount, description) VALUES (($1), ($2), 'Deposit')", current_user.id, amount)
    return results  

@router.post("/funds/withdraw")
async def add_funds(amount:int,
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    portfolio = await db.fetchrow("SELECT * FROM calculate_portfolio_totals(($1))", current_user.id)
    if portfolio:
        if amount > portfolio["available_funds"]:
            print('Not enough funds')
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail="Not enough funds")
    results = await db.fetch("INSERT INTO funds(user_id, amount, description) VALUES (($1), ($2), 'Withraw')", current_user.id, -amount)
    return results  
