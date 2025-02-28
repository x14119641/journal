import pytest

@pytest.mark.asyncio
async def test_get_tickers(test_client):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No tickers !'

@pytest.mark.asyncio   
async def test_get_dividends(test_client):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No Dividends !'



@pytest.mark.asyncio   
async def test_get_dividends_by_ticker(test_client, auth_token):
    ticker = 'MAIN'
    response = await test_client.get(f"/stocks/dividends/{ticker}", headers=auth_token)
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No Dividend of MAiN !!! !'
    assert 'amount' in json_data[0].keys()

@pytest.mark.asyncio   
async def test_get_dividends_calendar(test_client,auth_token):
    month = 2 # February
    response = await test_client.get(f"/stocks/dividends/calendar/{month}", headers=auth_token)
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No data in calendars !'
    assert 'paymentDate' in json_data[0].keys()


@pytest.mark.asyncio   
async def test_get_stock_by_ticker(test_client):
    ticker = 'MTG'
    response = await test_client.get(f"/stocks/{ticker}")
    json_data = response.json()
    assert response.status_code == 200
    print(json_data.keys())
    assert 'ratioHoldersBuySold' in json_data.keys()
    # I guess there is not enough data to get MAIN, but i get MTG. i guess i need to check the query
    # Now is working I dont know what happened
    ticker = 'MAIN'
    response = await test_client.get(f"/stocks/{ticker}")
    json_data = response.json()
    print(json_data)
    assert response.status_code == 200
    
"""
NEED MORE DATA TO TEST THE SCEENER 
@pytest.mark.asyncio   
async def test_get_stock_by_screener(test_client, db):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No tickers !'
    



"""

"""
I am not using those at the moment
@pytest.mark.asyncio   
async def test_get_favorites(test_client, db):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No tickers !'
    
    
@pytest.mark.asyncio   
async def test_remove_favorites(test_client, db):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No tickers !'
    
    
@pytest.mark.asyncio   
async def test_add_favorites(test_client, db):
    response = await test_client.get("/stocks/tickers/")
    json_data = response.json()
    assert response.status_code == 200
    assert len(json_data) > 0, 'No tickers !'
""" 
