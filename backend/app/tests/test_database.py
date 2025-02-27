import pytest, pytest_asyncio
from ..services.database import Database
from ..config import Settings
import asyncio


@pytest_asyncio.fixture(scope='session', loop_scope='session')
async def db():
    database = Database(**Settings.read_file('test_config.json'))
    await database.create_pool()
    
    # Safety check
    db_name = await database.fetchone("SElect current_database();")
    assert db_name == "test_db", "Tests only in test db!!"
    
    yield database
    await database.close_pool()


@pytest.mark.asyncio(loop_scope="session")
async def test_create_schema(db):
    await db.execute("DROP SCHEMA public CASCADE; CREATE SCHEMA public;")

    # # # Check database is clean
    number_tables = await db.fetchone("SELECT COUNT (table_name) FROM information_schema.tables WHERE table_schema='public';")

    assert number_tables == 0
    await db.create_schema()
    # Verify if any table is created
    result = await db.fetch(
        """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_name = 'users'
        """
    )
    print('result: ', result)
    assert len(result) == 1, "Table 'users' was not created"
    
    
@pytest.mark.asyncio(loop_scope="session")
async def test_create_test_user(db):
    # await db.create_pool()
    await db.execute("INSERT INTO users VALUES (1, 'test', 'test@email.com', 'test')")
    # Verify if any table is created
    result = await db.fetchone(
        """
        SELECT id
        FROM users
        WHERE username = 'test'
        """
    )
    assert result ==1, "Test user not created"