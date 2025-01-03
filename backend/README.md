# Backend: FastAPI backend + PostgresSQL #

## Step1: Create the configuration files 
You need to set some configuration files in the following format and structure:
### Main Configuration File for postgres: `app/config.json`
```json
{
    "host": "127.0.0.1",
    "user": "",
    "password": "",
    "database": "journal_app"
}
```
### Test Configuration File for user:**test** in postgres: `app/test_config.json`
```json
{
    "host": "127.0.0.1",
    "user": "test",
    "password": "",
    "database": "journal_app"
}
```
### Add secrets file: `app/secrets.json`
```json
{
    "SECRET_KEY": "your secret",
    "ACCESS_TOKEN_EXPIRE_MINUTES": 30,
    "ALGORITHM": "HS256"
}
```

## Step2: Set Up PostgresSQL #
- Create the 'test' user in the postgres server and if you want create another one for this application, otherwise just use the postgres user.*These are the 'credentials' you put in the step1.*
- Create the database journal_app


# Step3: Set Up Database Schema #
Create the database schema, you can use the sql file in: `app/test_config.json` or use the pytest library to run the test: `app/tests/test_database.py` and this will create the schema.

# Step4: Install Python libraries and Run
```
# With poetry
poetry init
# With requirements file
# pip install -r requirements.txt
# Run in dev mode
fastapi dev app/main.py
# Run in prod
# fastapi run app/main.py
```
