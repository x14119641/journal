import pytest

@pytest.mark.asyncio
async def test_(test_client, db):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No tickers !'