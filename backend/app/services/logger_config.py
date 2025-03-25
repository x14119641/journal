import logging
import sys
import os  
from logging.handlers import RotatingFileHandler

MAX_LOG_SIZE = 10000000 # 10MB

# Check if exists logs in app/logs
LOG_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'logs'))
os.makedirs(LOG_DIR, exist_ok=True)

LOG_FORMAT = logging.Formatter("%(asctime)s - %(levelname)s - %(name)s - %(message)s")

def get_logger(service_name, log_file):
    """Creaets a logger for a especific service with a rotator file handler."""
    logger = logging.getLogger(service_name)
    logger.setLevel(logging.INFO)
    
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(LOG_FORMAT)
    
    file_handler = RotatingFileHandler(
        os.path.join(LOG_DIR, log_file), 'a+', maxBytes=MAX_LOG_SIZE, backupCount=5
    )
    file_handler.setFormatter(LOG_FORMAT)

    # Avoid duplicate handlers
    if not logger.hasHandlers():
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)

    return logger