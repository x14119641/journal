from ..dependencies import get_db, UnicornException
from ..services.database import Database
from ..schema import BuyStock, SellStock, TransactionAmountDescription, UserLogin
from .auth import get_current_active_user
from fastapi import Depends, Response, status, APIRouter, HTTPException
from typing import Annotated
from asyncpg.exceptions import PostgresError 

import json


router = APIRouter(prefix='/transactions', tags=["Transaction",])



@router.post("/add_funds", status_code=status.HTTP_201_CREATED)
async def add_funds(
    transaction: TransactionAmountDescription,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    try:
        # Use execute() instead of fetch() since we are calling a stored procedure
        await db.execute(
            """CALL deposit_funds($1, $2, $3);""",
            current_user.id, transaction.amount, transaction.description
        )

        return {"message": "Funds added successfully"}

    except PostgresError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )

@router.post("/withdraw_funds", status_code=status.HTTP_201_CREATED)
async def withdraw_funds(
    transaction:TransactionAmountDescription,
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],
    db:Database=Depends(get_db)):
    try:
        await db.execute(
            """CALL withdraw_funds($1, $2, $3);""",
            current_user.id, transaction.amount, transaction.description
        )

        return {"message": "Funds withdrew successfully"}

    except PostgresError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )

@router.post("/buy_stock", status_code=status.HTTP_201_CREATED)
async def buy_stock(transaction:BuyStock,current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    try:
        return_msg = await db.fetchone("SELECT buy_stock(($1), ($2), ($3), ($4), ($5))", 
                        current_user.id, transaction.ticker, transaction.buy_price, 
                        transaction.quantity,transaction.fee)

        return {"message": return_msg}

    except PostgresError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error")
    
@router.post("/sell_stock", status_code=status.HTTP_201_CREATED)
async def buy_stock(transaction:SellStock,current_user:Annotated[UserLogin, Depends(get_current_active_user)],db:Database=Depends(get_db) ):
    try:
        return_msg = await db.fetchone("""
                                       SELECT sell_stock(($1), ($2), ($3), ($4), ($5))""", 
                                       current_user.id, transaction.ticker, transaction.price, 
                                       transaction.quantity,transaction.fee)

        return {"message": return_msg}

    except PostgresError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error")
    



@router.get("/get_transaction_history")
async def get_transaction_history(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetch("SELECT * FROM get_transaction_history(($1))", current_user.id)
    # print(results)
    if results is None:
        raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
                                detail="Transaction is empty")
    return results







@router.get("/latest")
async def get_transactions(
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],
    db:Database=Depends(get_db),
    limit:int=10):
    results = await db.fetch("""
                             SELECT ticker, quantity, price, transaction_type, 
                             price*quantity as total, 
                             created_at 
                             FROM transactions WHERE user_id = ($1) LIMIT ($2)""",
                             current_user.id, limit)
    if not results:
        return []
    return results  



@router.delete("/reset", status_code=status.HTTP_200_OK)
async def reset_user_transactions(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    """Delete all transactions, portfolio data, and reset balance for the user."""
    print(current_user)
    if current_user.username == 'test_user':
    
        await db.execute("CALL reset_user_data($1)", current_user.id)
        return {"message": "User transactions and portfolio reset successfully"}
    else:
        raise HTTPException(status_code=500, detail="Method not allawed")