import os
import json
from functools import lru_cache
from dotenv import load_dotenv
from pydantic import BaseModel

class Settings:
    @staticmethod
    @lru_cache()
    def load_env():
        filename = ".env.test" if os.getenv("TESTING") == "true" else ".env"
        load_dotenv(dotenv_path=filename, override=True)

    @staticmethod
    def get_db_config():
        Settings.load_env()
        return {
            "host": os.getenv("DB_HOST", "localhost"),
            "user": os.getenv("DB_USER", "postgres"),
            "password": os.getenv("DB_PASSWORD", "postgres"),
            "database": os.getenv("DB_NAME", "journal_app"),
            "port": int(os.getenv("DB_PORT", 5432)),
        }

class Secrets(BaseModel):
    SECRET_KEY:str
    REFRESH_SECRET_KEY:str
    ALGORITHM:str
    ACCESS_TOKEN_EXPIRE_MINUTES:int
    @staticmethod
    def load():
        return Secrets(
            SECRET_KEY= os.getenv("SECRET_KEY", "dev-key"),
            ALGORITHM= os.getenv("ALGORITHM", "HS256"),
            REFRESH_SECRET_KEY=os.getenv("REFRESH_SECRET_KEY", ""),
            ACCESS_TOKEN_EXPIRE_MINUTES= int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30")),
        )