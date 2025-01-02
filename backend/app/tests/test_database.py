import pytest, pytest_asyncio
from ..services.database import Database
from ..config import Settings
import asyncio


@pytest_asyncio.fixture(scope='session', loop_scope='session')
async def db():
    database = Database(**Settings.read_file('test_config.json'))
    return database


@pytest.mark.asyncio
async def test_create_schema(db):
    await db.create_pool()
    await db.create_schema()
    # Verify if any table is created
    result = await db.fetch(
        """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_name = 'users'
        """
    )
    assert len(result) == 1, "Table 'users' was not created"
    
    
# @pytest.mark.asyncio
# async def test_create_test_user(db):
#     await db.create_pool()
#     await db.execute("INSERT INTO users VALUES (1, 'test', 'test@email.com', 'test')")
#     # Verify if any table is created
#     result = await db.fetch(
#         """
#         SELECT id
#         FROM users
#         WHERE username = 'test'
#         """
#     )
#     assert result is None, "Test user not created"