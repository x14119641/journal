from decimal import Decimal
import pandas as pd
import numpy as np
from datetime import datetime


def simulate_portfolio_no_drip(initial_balance:float, start_date:str, end_date:str, portfolios:dict,historical_df:pd.DataFrame, dividends_df:pd.DataFrame):
    start_date = pd.to_datetime(start_date)
    end_date = pd.to_datetime(end_date)
    
    print(historical_df.keys())
    #Ensure indes is datetime, then with the index i can get the hiostorical close date like  historical_df[date, 'MAIN']
    historical_df.index = pd.to_datetime(historical_df.index)
    dividends_df["payment_date"] = pd.to_datetime(dividends_df["payment_date"])
    # Clean nones and duplicates
    dividends_df = (
        dividends_df[dividends_df["payment_date"].notna()]
        .drop_duplicates(subset=["ticker", "payment_date", "amount"])
    )
    # Get latest date of df, (if input is 1990)
    if start_date < historical_df.index.min():
        start_date = historical_df.index.min()
    all_dates = pd.date_range(start=start_date,end=end_date, freq="D")
    
        
    result = {}
    
    for portfolio, assets in portfolios.items():
        #Prepare 
        cash = 0.0
        last_valid_invested_value = 0.0
        holdings = {}
        print(f"\n📊 Simulating {portfolio}")
        for asset in assets:
            ticker = asset.stock
            weigth = asset.weigth / 100

            price_on_start = historical_df.loc[start_date, ticker]

            # Check if price is na, it it is, then get first date with dividend for that ticker
            if pd.isna(price_on_start):
                first_valid_date = historical_df[ticker].first_valid_index()
                if first_valid_date is None:
                    print(f"--Skiping-- No dividend data for ticker {ticker}")
                    continue
                price_on_start = historical_df.at[first_valid_date, ticker]

            amount_allocated = initial_balance * weigth
            shares = amount_allocated / price_on_start
            holdings[ticker] = shares
            print(f"  {ticker}: {shares:.4f} shares @ {price_on_start:.2f}")

        # Track dividends time series
        records = []
        
        for day in all_dates:
            if day not in historical_df.index:
                continue
            
            
            # Try to compute invested value for today if there is no data for dividends "this month"
            # Like this i can go back to the latest price
            prices_found = False
            invested_value_today = 0.0
            
            for ticker in holdings:
                try:
                    price = historical_df.at[day, ticker]
                    if not pd.isna(price):
                        invested_value_today += holdings[ticker] * price
                        prices_found = True
                except Exception as e:
                    continue
            
            # If prices were valid today, update tracker
            if prices_found:
                last_valid_invested_value = invested_value_today
                invested_value = invested_value_today
            else:
                
                #Otherwise go back to the last known value
                invested_value = last_valid_invested_value if last_valid_invested_value is not None else 0.0
                
            # invested_value = sum(
            #     holdings[ticker] * historical_df.at[day, ticker]
            #     for ticker in holdings if not pd.isna((price := historical_df.at[day, ticker]))
            # )
            
            # Check dividends payable today
            today_dividends = dividends_df[dividends_df["payment_date"] == day]

            
            for _, row in today_dividends.iterrows():
                ticker = row["ticker"]
                if ticker not in holdings:
                    continue
                amount = float(row["amount"])
                shares = holdings.get(ticker)
                dividend_payment = amount * shares
                # print(f"  {ticker}: {row['amount']} * {Decimal(shares):.4f} = {row['amount'] * Decimal(shares):.4f}")
                cash += dividend_payment
            
            total_value = invested_value + cash
            records.append({
                "date":day.strftime("%Y-%m-%d"),
                "invested_value": round(invested_value, 2),
                "cash": round(cash, 2),
                "total_value": round(total_value, 2)
            })
        result[portfolio] = records
        print(f"{portfolio} final value: {records[-1]}")
     
        # print("==== PORTFOLIO CONFIG ====")
        # for p, assets in portfolios.items():
        #     print(f"{p}:")
        #     for a in assets:
        #         print(f"  {a.stock} - {a.weigth}%")



    return result