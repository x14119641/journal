from fastapi import Depends, status, HTTPException, APIRouter
from .auth import get_current_active_user
from ..services.database import Database
from ..schema import (User, UserBase, UserCreate, UserLogin, UserResponse)
from ..dependencies import get_db, oauth2_scheme, password_hash
from typing import Annotated


router = APIRouter(prefix="/users", tags=["Users"]) 

@router.post("/", status_code=status.HTTP_201_CREATED, response_model=User)
async def create_post(user:UserCreate, db:Database=Depends(get_db)):
    # email an user validiations
    email_exists = await db.fetchone("SELECT email FROM users WHERE email=($1)", user.email)
    if email_exists:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Email already registered.')
    
    username_exists = await db.fetchone("SELECT username FROM users WHERE username=($1)", user.username)
    if username_exists:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='User already registered.')
    
    
    hashed_pwd = password_hash.hash(user.password)
    
    row = await db.fetchrow(
        "INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING *", 
        user.username, user.email, hashed_pwd,)
    data = await db.fetchrow("SELECT * FROM users WHERE id = ($1)", row['id'],)
    return data



@router.get("/me")
async def read_own_items(
    current_user: Annotated[User, Depends(get_current_active_user)],
    db:Database=Depends(get_db) 
):
    return {"id":current_user.id, "username":current_user.username}

@router.get("/me/items", response_model=UserResponse)
async def read_own_items(
    current_user: Annotated[User, Depends(get_current_active_user)], 
    db:Database=Depends(get_db)
):
    # Find user
    user = await db.fetchrow("SELECT * FROM users WHERE id=($1) LIMIT 1", current_user.id,)
    print(user)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='ID not found ')
    return user

@router.get("/{_id}", response_model=UserResponse)
async def get_user_by_id(
    _id:int, 
    current_user:Annotated[UserLogin, Depends(get_current_active_user)],
    db:Database=Depends(get_db)):
    # Find user
    user = await db.fetchrow("SELECT * FROM users WHERE id=($1) LIMIT 1", _id,)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='ID not found ')
    return user
    

