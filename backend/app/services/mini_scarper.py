import yfinance as yf
from concurrent.futures import ThreadPoolExecutor
from typing import List
from ..schema import TickerPrice, TickerSharesOutstanding


def get_current_price_ticker(ticker:str) -> TickerPrice:
    try:
        stock = yf.Ticker(ticker)
        return TickerPrice(ticker=ticker, price=round(stock.fast_info['lastPrice'],2))
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