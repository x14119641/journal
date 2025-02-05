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
    results = await db.fetch("SELECT * FROM users;")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not posts")
    return  results
