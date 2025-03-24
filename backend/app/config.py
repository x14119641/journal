from pydantic_settings import BaseSettings
import json, os

class Settings(BaseSettings):
    app_name:str = 'Journal App'
    host:str
    user:str
    pasword:str
    database:str
    port:str
    #model_config = SettingsConfigDict(env_file="config.env")
    
    @staticmethod
    def read_file(config_path: str = 'config.json') -> dict:
        # Priority: absolute path > relative to cwd > fallback to same dir as this file
        possible_locations = [
            config_path,  # allow absolute path or relative to cwd
            os.path.join(os.path.dirname(os.path.realpath(__file__)), config_path),  # relative to project root (e.g., in CI)
            os.path.join(os.path.dirname(__file__), config_path),  # default: next to config.py
        ]
        print('*'*9)
        print("🔁 ENV TESTING:", os.getenv("TESTING"), flush=True)
        print('*'*9)
        
            
        for path in possible_locations:
            if os.getenv("TESTING"):
                json_file = {
                    "host": "localhost",
                    "user": "test",
                    "password": "test",
                    "database": "test_db",
                    "port": 5432
                }
            elif os.path.isfile(path):
                with open(path) as json_file:
                    return json.load(json_file)

        raise FileNotFoundError(f"Could not find config file: {json_file}")
    
class Secrets(BaseSettings):
    SECRET_KEY:str
    ACCESS_TOKEN_EXPIRE_MINUTES:int
    ALGORITHM:str