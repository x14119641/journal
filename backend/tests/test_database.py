import pytest
import asyncio



@pytest.mark.asyncio
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
    # print('result: ', result)
    assert len(result) == 1, "Table 'users' was not created"
    
# Insert some raw data
pytest.mark.asyncio
async def test_insert_some_data(db):
    await db.insert_test_data()
    result = await db.fetch(
        """
        SELECT *
        FROM tickers
        """
    )
    assert len(result) == 6, "Not all tickers are in tickers"
    await db.insert_test_data()
    result = await db.fetch(
        """
        SELECT *
        FROM institutional_holdings
        """
    )
    assert len(result) == 6, "Not all tickers are in institutuional_holdings"
    
@pytest.mark.asyncio
async def test_create_test_user(db):
    await db.create_pool()
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
    

@pytest.mark.asyncio
async def test_fetchone(db):
    # await db.create_pool()
    val = await db.fetchone("SELECT 1+1")
    # Verify if any table is created
    assert val ==2, "FetchVal is not working"
    
@pytest.mark.asyncio
async def test_fetchrow(db):
    # await db.create_pool()
    row = await db.fetchrow("SELECT * FROM users LIMIT 1")
    assert  isinstance(row,dict), "Fetchrow is not retuurining a single dict"
    
@pytest.mark.asyncio
async def test_remove_user(db):
    # await db.create_pool()
    row = await db.fetchrow("DELETE FROM users WHERE username='test'")
    assert row is None