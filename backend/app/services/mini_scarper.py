import yfinance as yf
from concurrent.futures import ThreadPoolExecutor
from typing import List
from ..schema import TickerPrice, TickerSharesOutstanding
from datetime import datetime

def get_current_price_ticker(ticker:str) -> TickerPrice:
    try:
        stock = yf.Ticker(ticker)

        # return TickerPrice(ticker=ticker, price=round(stock.fast_info['lastPrice'],2))
        return {'ticker':ticker, 'price':round(stock.fast_info['lastPrice'],2)}
    except Exception:
        pass

def get_tickers_historical_close(tickers:List[str], start_date, end_date=None):
    if not end_date:
        end_date=datetime.today().strftime('%Y-%m-%d')
    try:
        str_tickers = " ".join(tickers)
        print(str_tickers)
        data = yf.download(str_tickers, start=start_date, end=end_date, auto_adjust=False)['Close']
        print('Data: ')
        print(data)
        return data
    except Exception:
        pass
    

def get_current_outstanding_shares_ticker(ticker:str):
    try:
        stock = yf.Ticker(ticker)
        return stock.info['sharesOutstanding']
    except Exception:
        pass
    
     
def get_current_price_tickers(tickers:List[str])->List[TickerPrice]:
    with ThreadPoolExecutor() as executor:
        return executor.map(get_current_price_ticker, tickers)
    
