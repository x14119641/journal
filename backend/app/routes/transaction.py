from ..dependencies import get_db
from ..services.database import Database
from ..schema import UserLogin, Transaction
from .auth import get_current_active_user
from fastapi import Depends, Response, status, APIRouter, HTTPException
from typing import Annotated
import json


router = APIRouter(prefix='/transactions', tags=["Transaction",])


@router.get("/latest")
async def get_transactions(
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],
    db:Database=Depends(get_db),
    limit:int=10):
    results = await db.fetch("""
                             SELECT ticker, quantity, price, transactionType, price*quantity as total, created_at FROM transactions WHERE user_id = ($1) LIMIT ($2)""",
                             current_user.id, limit)
    if not results:
        return []
    return results  


@router.post("/add")
async def add_transaction(transaction:Transaction,current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    result = await db.fetchone("SELECT add_transaction(($1),($2),($3),($4),($5),($6))", 
                        current_user.id, transaction.ticker, transaction.price, transaction.quantity, transaction.transaction_type,transaction.fee)
    print('Result: ', result)
    print(current_user.id, transaction.ticker, transaction.price, transaction.quantity, transaction.transaction_type,transaction.fee)
    return {'message':result}