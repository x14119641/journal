from pydantic import BaseModel, EmailStr, Field
from pydantic.types import conint
from typing import Optional
from datetime import datetime
from decimal import Decimal




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
    

class BuyStock(BaseModel):
    ticker:str
    buy_price:Decimal
    quantity:Decimal
    fee: Decimal=Field(2)

class SellStock(BaseModel):
    ticker:str
    price:Decimal
    quantity:Decimal
    fee: Decimal=Field(2)
    
    
class TransactionAmountDescription(BaseModel):
    amount:Decimal
    description:str
    
    
    
    
class Ticker(BaseModel):
    ticker:str
    price:Decimal
    
class TickerPrice(BaseModel):
    ticker:str
    price:Decimal
    
class TickerSharesOutstanding(BaseModel):
    ticker:str
    sharesOutstanding:int
