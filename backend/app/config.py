from pydantic_settings import BaseSettings
import  os
from dotenv import load_dotenv

# # Always load from the backend root
# env_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')
# load_dotenv(dotenv_path=env_path)

class Settings(BaseSettings):
    app_name:str = 'Journal App'
    host:str
    user:str
    pasword:str
    database:str
    port:str
    
    @staticmethod
    def load_env():
        env_file = ".env.test" if os.getenv("TESTING") == "true" else ".env"
        print('ENV FILE; ', env_file)
        env_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), env_file)
        load_dotenv(dotenv_path=env_path)

    @staticmethod
    def get_db_config():
        return {
            "host": os.getenv("DB_HOST"),
            "user": os.getenv("DB_USER"),
            "password": os.getenv("DB_PASSWORD"),
            "database": os.getenv("DB_NAME"),
            "port": int(os.getenv("DB_PORT", 5432)),
        }
    
class Secrets(BaseSettings):
    SECRET_KEY: str
    ALGORITHM: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int

    @staticmethod
    def load() -> "Secrets":
        return Secrets(
            SECRET_KEY=os.getenv("SECRET_KEY", "fallback"),
            ALGORITHM=os.getenv("JWT_ALGORITHM", "HS256"),
            ACCESS_TOKEN_EXPIRE_MINUTES=int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))
        )