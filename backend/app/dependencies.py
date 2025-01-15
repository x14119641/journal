# dependencies.py
from fastapi.security import OAuth2PasswordBearer
from pwdlib import PasswordHash
from .services.database import Database
from .config import Settings, Secrets
from datetime import datetime, timedelta


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")
password_hash = PasswordHash.recommended()

settings = Settings.read_file()
secrets = Secrets(**Settings.read_file('secrets.json'))


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
    