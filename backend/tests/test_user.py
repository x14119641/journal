import pytest

@pytest.mark.asyncio
async def test_create_user(test_client, db):
    response = await test_client.post("/users/",
                                json={
                                    "username":"new_user",
                                    "email": "new_user@email.com",
                                    "password": "new_pwd",
                                })
    assert response.status_code == 201


@pytest.mark.asyncio
async def test_user_already_there(test_client, db):
    response = await test_client.post("/users/",
                                json={
                                    "username":"new_user",
                                    "email": "new_user@email.com",
                                    "password": "new_pwd",
                                })
    assert response.status_code == 400

@pytest.mark.asyncio
async def test_wrong_email(test_client, db):
    response = await test_client.post("/users/",
                                json={
                                    "username":"new_user2",
                                    "email": "new_uail.com",
                                    "password": "new_pwd2",
                                })
    assert response.status_code == 422


# Protected (we using the token from contfest, user is test_user)
# First we need to login and get the token that is done in the conftest
@pytest.mark.asyncio
async def test_me(test_client, auth_token):
    response = await test_client.get("/users/me", headers=auth_token)
    assert response.status_code == 200
    user_data = response.json()
    assert user_data["username"] == "test_user", "Incorrect username returned"

@pytest.mark.asyncio
async def test_me_items(test_client, auth_token):
    response = await test_client.get("/users/me/items", headers=auth_token)
    assert response.status_code == 200
    user_data = response.json()
    assert user_data["username"] == "test_user", "Incorrect username returned"
    assert user_data["email"] == "test_user@email.com", "Incorrect email returned"
    

@pytest.mark.asyncio
async def test_remove_users(db):
    await db.create_pool()
    await db.fetchrow("DELETE FROM users WHERE username='new_user' OR username='new_user2' OR username='test'")
    assert True, "Test users Not DELETED !!"