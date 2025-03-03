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
    def read_file(config_path:str='config.json') -> dict:
        file_dir = os.path.dirname(os.path.realpath(__file__))
        with open(os.path.join(file_dir, config_path)) as json_file:
            data = json.loads(json_file.read())
        return data
    
class Secrets(BaseSettings):
    SECRET_KEY:str
    ACCESS_TOKEN_EXPIRE_MINUTES:int
    ALGORITHM:str