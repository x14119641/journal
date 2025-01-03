from fastapi import Response, status, HTTPException, APIRouter
from ..schema import (User, UserBase, UserCreate, UserLogin, UserResponse)
from ..dependencies import db, oauth2_scheme, password_hash
from typing import List


router = APIRouter(prefix="/users", tags=["Users"]) 

@router.post("/", status_code=status.HTTP_201_CREATED, response_model=User)
async def create_post(user:UserCreate):
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



@router.get("/{_id}", response_model=UserResponse)
async def get_user_by_id(_id:int):
    # Find user
    user = await db.fetchrow("SELECT * FROM users WHERE id=($1) LIMIT 1", _id,)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='ID not found ')
    return user
    