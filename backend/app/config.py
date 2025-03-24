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
            os.path.join(os.getcwd(), config_path),  # relative to project root (e.g., in CI)
            os.path.join(os.path.dirname(__file__), config_path),  # default: next to config.py
        ]

        for path in possible_locations:
            if os.path.isfile(path):
                with open(path) as json_file:
                    return json.load(json_file)

        raise FileNotFoundError(f"Could not find config file: {config_path}")
    
class Secrets(BaseSettings):
    SECRET_KEY:str
    ACCESS_TOKEN_EXPIRE_MINUTES:int
    ALGORITHM:str