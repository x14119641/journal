from ..dependencies import get_db
from ..services.database import Database
from ..schema import BuyStock, SellStock, TransactionDelete, TransactionFund, UpdateTransactionDescription, UserLogin
from .auth import get_current_active_user
from fastapi import Depends, status, APIRouter, HTTPException
from typing import Annotated
from asyncpg.exceptions import PostgresError
from datetime import datetime, timezone


router = APIRouter(prefix='/transactions', tags=["Transaction",])


@router.post("/add_funds", status_code=status.HTTP_201_CREATED)
async def add_funds(
    transaction: TransactionFund,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    print('transaction: ', transaction)
    if transaction.created_at:
        if transaction.created_at.tzinfo is not None:
            _formated_date = transaction.created_at.astimezone(
                timezone.utc).replace(tzinfo=None)
        else:
            _formated_date = transaction.created_at
    else:
        _formated_date = datetime.now()
    try:
        # Use execute() instead of fetch() since we are calling a stored procedure
        msg = await db.execute(
            """SELECT deposit_funds($1, $2, $3, $4);""",
            current_user.id, transaction.amount, transaction.description,
            _formated_date
        )

        return {"message": msg}

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
        transaction: TransactionFund,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    print('transaction: ', transaction)
    if transaction.created_at:
        if transaction.created_at.tzinfo is not None:
            _formated_date = transaction.created_at.astimezone(
                timezone.utc).replace(tzinfo=None)
        else:
            _formated_date = transaction.created_at
    else:
        _formated_date = datetime.now()
    try:
        msg = await db.fetchone(
            """SELECT withdraw_funds($1, $2, $3, $4);""",
            current_user.id, transaction.amount, transaction.description,
            _formated_date
        )

        return {"message": msg}

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
async def buy_stock(transaction: BuyStock, current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
    try:
        print("Stock Buy: ", transaction)
        if transaction.created_at:
            if transaction.created_at.tzinfo is not None:
                _formated_date = transaction.created_at.astimezone(
                    timezone.utc).replace(tzinfo=None)
            else:
                _formated_date = transaction.created_at
        else:
            _formated_date = datetime.now()
        return_msg = await db.fetchone("SELECT buy_stock($1, $2, $3, $4, $5, $6)",
                                       current_user.id, transaction.ticker, transaction.buy_price,
                                       transaction.quantity, transaction.fee,
                                       _formated_date)

        if return_msg is None:
            return {"message": "Nothing to buy"}
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
async def sell_stock(transaction: SellStock, current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
    try:
        print("Stock Sell: ", transaction)
        if transaction.created_at:
            if transaction.created_at.tzinfo is not None:
                _formated_date = transaction.created_at.astimezone(
                    timezone.utc).replace(tzinfo=None)
            else:
                _formated_date = transaction.created_at
        else:
            _formated_date = datetime.now()
        return_msg = await db.fetchone("""
                                       SELECT sell_stock($1, $2, $3, $4, $5, $6)""",
                                       current_user.id, transaction.ticker, transaction.price,
                                       transaction.quantity, transaction.fee,
                                       _formated_date)

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
        db: Database = Depends(get_db),
        limit: int = 10):
    results = await db.fetch(
        """SELECT id as "transactionId" ,ticker, price,quantity, transaction_type  as "transactionType",
            fee, description, created_at 
            FROM transactions WHERE user_id=($1) 
            ORDER BY created_at DESC LIMIT ($2);""", current_user.id, limit)
    print(results)
    if results is None:
        raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
                            detail="Transaction is empty")
    return results


@router.get("/get_stocks_transactions_history")
async def get_stocks_transaction_history(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db),
):
    results = await db.fetch(
        """SELECT id as "transactionId",ticker, price, quantity, fee,
                transaction_type as "transactionType", 
                realized_profit_loss as "realizedProfitLoss", 
                description, created_At 
            FROM transactions
            WHERE user_id = ($1)
            AND ticker is NOT NULL
            ORDER BY created_at DESC;""", current_user.id)
    print(results)
    if results is None:
        raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
                            detail="Transaction is empty")
    return results


@router.get("/latest")
async def get_transactions(
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db),
        limit: int = 10):
    results = await db.fetch("""
                             SELECT id as "transactionId", ticker, quantity, price, transactionType, 
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

@router.post("/{transactionId}/description/update")
async def update_description_transaction(
        transaction:UpdateTransactionDescription,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db),
        ):
    print("Tranaciton: ", transaction)
    id = await db.fetchone("""
                             UPDATE transactions
                             SET description = $1
                             WHERE id = $2
                             AND user_id=$3
                             RETURNING id
                             """,
                             transaction.des,transaction.transaction_id,current_user.id)
    if not id:
        msg = "Nothin has been updated"
        return {"message": "Nothin has been updated"}
    return {"message": f"TransactionID: {str(id)} updated!"}


@router.post("/{transactionId}/delete")
async def deletes_stock_transaction_by_id(
        transaction:TransactionDelete,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db),
        ):
    print("Transaction: ", transaction)
    VALID_TYPES = ["SELL", "BUY", "DEPOSIT", "WITHDRAW"]

    if transaction.transaction_type not in VALID_TYPES:
        return {"message": "Invalid transaction type."}

    if transaction.transaction_type =="SELL":
        msg = await db.fetchone("""
                             SELECT delete_sell_transaction($1,$2, $3);
                             """,
                             current_user.id, transaction.transaction_id, transaction.reason)
    elif transaction.transaction_type =="BUY":
        msg = await db.fetchone("""
                             SELECT delete_buy_transaction($1,$2, $3);
                             """,
                             current_user.id, transaction.transaction_id, transaction.reason)
    elif transaction.transaction_type =="DEPOSIT":
        msg = await db.fetchone("""
                             SELECT delete_deposit_transaction($1,$2, $3);
                             """,
                             current_user.id, transaction.transaction_id, transaction.reason)
    elif transaction.transaction_type =="WITHDRAW":
        msg = await db.fetchone("""
                             SELECT delete_withdraw_transaction($1,$2, $3);
                             """,
                             current_user.id, transaction.transaction_id, transaction.reason)
    else:
        msg = "Cannot handle Transaction type. Nothing deleted"
    if not msg:
        msg = "Nothin has been deleted."
    print("MESSAGE: ", msg)
    return {"message": msg}


@router.get("/{transactionId}/type")
async def get_transaction_type_by_id(
        transactionId: int,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    result = await db.fetchone("""
                             SELECT 
                                CASE 
                                    WHEN (ticker IS NULL) THEN 'Balance'
                                    WHEN (ticker IS NOT NULL) THEN 'Stock' 
                                ELSE '404' 
                                END as transactionType
                            FROM transactions
                            WHERE id = $1
                            AND user_id=$2;""",
                             transactionId, current_user.id)
    print('Resul : ', result)
    if not result:
        result = "404"
    return {"value":result}

@router.get("/{transactionId}")
async def get_transaction_by_id(
        transactionId: int,
        current_user: Annotated[UserLogin, Depends(get_current_active_user)],
        db: Database = Depends(get_db)):
    results = await db.fetchrow("""
                             SELECT id, ticker, price, quantity, transaction_type as "transactionType", 
                                fee,realized_profit_loss as "realizedProfitLoss", description, created_at
                            FROM transactions
                            WHERE id = $1
                            AND user_id=$2;""",
                             transactionId, current_user.id)
    print('Resul : ', results)
    if not results:
        return []
    return results
