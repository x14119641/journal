# dependencies.py
from fastapi.security import OAuth2PasswordBearer
from fastapi import Request
from fastapi.responses import JSONResponse
# from ..app.main import app
from pwdlib import PasswordHash
from .services.database import Database
from .config import Settings, Secrets
from datetime import datetime, timedelta
import os


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")
password_hash = PasswordHash.recommended()

Settings.load_env()

settings = Settings.get_db_config()
secrets = Secrets.load()
print('SEttings: ', settings )
print('Secrets: ', secrets)


async def get_db():
    db = Database(**settings)
    await db.create_pool()
    try:
        yield db
    finally:
        await db.close_pool()
        
def last_day_of_month(any_date):
    # The day 28 exists in every month. 4 days later, it's always next month
    next_month = any_date.replace(day=28) + timedelta(days=4)
    return next_month - timedelta(days=next_month.day)



class UnicornException(Exception):
    """Custom Error Handler"""
    def __init__(self, message: str, status_code:int):
        self.message = message
        self.status_code = status_code

async def unicorn_exception_handler(request: Request, exc: UnicornException):
    return JSONResponse(
        status_code=int(exc.status_code),
        content={"message": exc.message},
    )