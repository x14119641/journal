from pydantic import BaseModel, EmailStr
from pydantic.types import conint
from typing import Optional
from datetime import datetime




class PostBase(BaseModel):
    title: str
    content: str
    published: bool = True
    # raiting: Optional[int] = None
    
class PostCreate(PostBase):
    pass


class PostOut(PostBase):
    votes:int
    created_at:datetime


class Post(PostBase):
    id:int
    created_at:datetime
    
    
class UserBase(BaseModel):
    username: str
    email:EmailStr
    disabled: bool | None = None
    
    
class User(UserBase):
    id:int
    username: str
    email:EmailStr
    created_at:datetime
    
    
class UserCreate(UserBase):
    password:str


class UserLogin(UserBase):
    id:int
    username: str 
    password:str

    
class UserResponse(BaseModel):
    id:int
    username: str
    email:EmailStr
    created_at:datetime
    

class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str | None = None
    
    
class Vote(BaseModel):
    post_id: int
    liked: conint(le=1)
    
    
class StockDividendRecord(BaseModel):
    tick:str
    ex_dividend_date:datetime|None
    payment_type:str
    amount:str
    declaration_date:datetime|None
    record_date:datetime|None
    payment_date:datetime|None
    currency:str
    
    
    
