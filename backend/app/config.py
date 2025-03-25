import os
import json
from functools import lru_cache
from dotenv import load_dotenv
print("📦 config.py loaded from", __file__)

class Settings:
    @staticmethod
    @lru_cache()
    def load_env():
        env_path = ".env.test" if os.getenv("TESTING") == "true" else ".env"
        load_dotenv(dotenv_path=env_path, override=True)

    @staticmethod
    def get_db_config():
        Settings.load_env()
        return {
            "host": os.getenv("DB_HOST", "localhost"),
            "user": os.getenv("DB_USER", "postgres"),
            "password": os.getenv("DB_PASSWORD", "postgres"),
            "database": os.getenv("DB_NAME", "journal_app"),
            "port": int(os.getenv("DB_PORT", 5432)),}
    
class Secrets:
    @staticmethod
    def load():
        return {
            "SECRET_KEY": os.getenv("SECRET_KEY", "dev-key"),
            "ALGORITHM": os.getenv("ALGORITHM", "HS256"),
            "ACCESS_TOKEN_EXPIRE_MINUTES": int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30")),
        }