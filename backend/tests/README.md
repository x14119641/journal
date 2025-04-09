# Preparing
1) We need to create database test_db
2) Create user test_user with the password in your .env.test
3) Set test_user owner of the test_Db
4) Create schema if not exists. 

# Run with:
```
export TESTING=true
pytest --asyncio-mode=auto --maxfail=1 -s
```

# Notes
Check if DB_HOST in .env.test is "localhost" (to test in docker) or "db" (to test in local)