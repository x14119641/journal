# dependencies.py
from fastapi.security import OAuth2PasswordBearer
from pwdlib import PasswordHash
from .services.database import Database
from .config import Settings, Secrets


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")
password_hash = PasswordHash.recommended()

settings = Settings.read_file()
secrets = Secrets(**Settings.read_file('secrets.json'))

db = Database(**settings)