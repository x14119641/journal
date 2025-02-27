# import pytest
# import asyncio
# from httpx import AsyncClient
# import app
# from app.services.database import Database
# from app.config import Settings


# @pytest.fixture(scope="session")
# async def test_client():
#     async with AsyncClient(app=app, base_url="http://test") as client:
#         yield client
        
# @pytest.fixture(scope="session")
# async def db():
#     """Fixture to create a test database."""
#     database = Database(**Settings.read_file("test_config.json"))
#     await database.create_pool()
#     yield database
#     await database.close_pool()
    

# @pytest.mark.asyncio(loop_scope="session")
# async def test_login(test_client, db):pass