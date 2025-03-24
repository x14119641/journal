import pytest, pytest_asyncio
from app.main import app
from app.services.database import Database
from app.config import Settings
from app.dependencies import password_hash
from fastapi.testclient import TestClient
from httpx import ASGITransport, AsyncClient
import asyncio
import os

os.environ["TESTING"] = "true"

CREDENTIALS = {
            "username": "test_user", 
            "email":"test_user@email.com",
            "password":"test_pass"}
    

@pytest.fixture(scope="session")
async def test_client():
    """FastAPI Test cient"""
    async with AsyncClient(
        transport=ASGITransport(app=app), base_url="http://test", follow_redirects=True
    ) as client:
        yield client
        
        
@pytest_asyncio.fixture
async def db():
    """Database fixture"""
    #  Test config must be in app
    database = Database(**Settings.read_file('test_config.json'))
    await database.create_pool()  
    # await database.create_schema() # If you dont  habve data in test it may be a good idea toc reate it beforehand.
    # Safety check
    # db_name = await database.fetchone("SElect current_database();")
    # assert db_name == "test_db", "Tests only in test db!!"
    
    yield database
    await database.close_pool()

# @pytest.fixture(scope="function")
# async def db_connection(db):
#     """Creates a new connection for each test to prevent conflicts."""
#     conn = await db.pool.acquire()  # ✅ Get a fresh connection
#     try:
#         async with conn.transaction():
#             yield conn  # ✅ Provide a separate connection for each test
#     finally:
#         await db.pool.release(conn)
              
# @pytest.fixture(scope="function")
# async def clean_users(db):
#     """DELETES test users after each test function runs"""
#     yield
#     await db.execute("TRUNCATE TABLE users")

# @pytest.fixture(scope="module")
# async def cleanup_users(db):
#     """Deletes test users after all tests in test_users.py."""
#     yield  # Run all tests first

#     async with db.pool.acquire() as conn:
#         async with conn.transaction():
#             await conn.execute("DELETE FROM users WHERE username='test_user'")
#             await conn.execute("DELETE FROM users WHERE username='new_user'")
#             await conn.execute("DELETE FROM users WHERE username='new_user2'")
    
@pytest.fixture
async def auth_token(test_client, db):
    """Creates a test user and logs in to get the auth token."""
    
    # Hash the password only once before storing
    hashed_password = password_hash.hash(CREDENTIALS["password"])
    
    # Insert the user directly into the database with the hashed password
    await db.execute(
        """
        INSERT INTO users (username, email, password) 
        VALUES ($1, $2, $3) 
        ON CONFLICT (username) DO NOTHING
        """,
        CREDENTIALS["username"],
        CREDENTIALS["email"],
        hashed_password
    )

    # Logs in with the plain-text password
    response = await test_client.post(
        "/login",
        data={"username": CREDENTIALS["username"], "password": CREDENTIALS["password"]}
    )

    assert response.status_code == 200, f"Login failed: {response.text}"
    
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}