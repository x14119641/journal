from typing import List, Annotated, Optional
from ..dependencies import get_db, last_day_of_month
from ..services.database import Database
from ..services.mini_scarper import get_current_outstanding_shares_ticker
from fastapi import Depends, Response, status, HTTPException, APIRouter
from .auth import get_current_active_user
from ..schema import (UserResponse, UserLogin, Post,
                      PostBase, PostCreate, PostOut)
from datetime import datetime
from decimal import Decimal
router = APIRouter(prefix='/stocks', tags=["Stocks"])


@router.get("/tickers")
async def get_tickers(db: Database = Depends(get_db)):
    results = await db.fetch(
        """SELECT ticker, company_name as "companyName" 
        FROM tickers ORDER BY ticker"""
    )
    # print("Results: ", results)
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not tickers")
    return results


@router.get("/dividends")
async def get_dividends(db: Database = Depends(get_db)):
    results = await db.fetch("""
                             SELECT * FROM dividends 
                             WHERE ex_dividend_date IS NOT NULL 
                             AND declaration_date IS NOT NULL 
                             ORDER BY ex_dividend_date DESC LIMIT 100""")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return results


@router.get("/dividends/myfavorites")
async def get_favorites(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    results = await db.fetch("""
                            SELECT f.ticker FROM tickers t 
                            INNER JOIN favorites f
                            ON t.ticker = f.ticker
                            INNER JOIN users u
                            ON f.user_id = u.id
                            WHERE u.id = ($1) """, current_user.id)
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return results


@router.delete("/dividends/myfavorites/remove")
async def remove_favorites(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):

    await db.execute("""
                            DELETE FROM favorites 
                            WHERE user_id = ($1) 
                            AND ticker = ($2)""", 
                            current_user.id, ticker)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post("/dividends/myfavorites/add")
async def add_favorites(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    results = await db.fetch("""
                            INSERT INTO favorites(ticker, user_id) 
                            VALUES ($1,$2) RETURNING 1""", 
                            ticker, current_user.id)
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return Response(status_code=status.HTTP_201_CREATED)


@router.get("/dividends/{ticker}")
async def get_dividends_by_ticker(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db)
):
    print("ticker: ", ticker)
    results = await db.fetch("""
                             SELECT ex_date, payment_type, amount, 
                             declaration_date, record_date, payment_date, currency 
                             FROM dividends 
                             WHERE ticker = ($1) 
                             ORDER BY ex_date DESC""", ticker.upper()
                             )
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not dividends")
    return results


@router.get("/dividends/calendar/{month}")
async def get_dividends_calendar(
    month: int,
    db: Database = Depends(get_db)
):
    # start_month = datetime(day=1, month=month, year=)
    # end_month = last_day_of_month(start_month)
    
    results = await db.fetch("""
                            SELECT d.ticker, d.amount, d.payment_date as "paymentDate" 
                            FROM dividends d
                            WHERE EXTRACT(YEAR FROM d.payment_date) = ($1) 
                                AND EXTRACT(MONTH FROM d.payment_date) =($2);
                             """, datetime.today().year, month)
    # print(results)
    return results


# stocks/screener
@router.get("/screener")
async def get_stock_by_screener(
    numDividends: Optional[int] = None,
    amountAbove: Optional[Decimal] = None,
    exDateMonth: Optional[int] = None,
    sector: Optional[str] = None,
    marketcap: Optional[int] = None,
    peratio: Optional[Decimal] = None,
    forwardpe1yr: Optional[Decimal] = None,
    earningspershare: Optional[Decimal] = None,
    annualizeddividend: Optional[Decimal] = None,
    annualyield: Optional[Decimal] = None,
    sharesoutstandingpct: Optional[Decimal] = None,
    ratioholdersbuysold: Optional[Decimal] = None,
    db: Database = Depends(get_db)
):
    this_year = datetime.today().year
    #  So far now, if there is not data in instutionals we dont show data,
    # This is because i am doind a left join, at the moment i leave it like that
    # Not sure if i will need to handle nulls and now i dont want the hasle
    """
    # We build the query dinamically as i dont want to query a lot of data a lot of time and then filter
    The query looks like:
        WITH DividendCount AS (
            SELECT ticker, COUNT(ticker) AS "numDividends", amount
            FROM dividends 
            bla bla
        ),
        FindExDate AS (
            SELECT ticker, MIN(declaration_date) AS "declarationDate"
            FROM dividends
            WHERE EXTRACT(YEAR FROM declaration_date) = EXTRACT(YEAR FROM CURRENT_DATE)
                AND EXTRACT(MONTH FROM declaration_date) = {month}
        )
        SELECT bla bla bla
        FROM DividendCount dd
        JOIN FindExDate f ON f.ticker = dd.ticker
        JOIN metadata m ON m.ticker = dd.ticker
        JOIN institutional_holdings ih ON ih.ticker = dd.ticker
        -- Conditional Some WHEREs ...
    """
    # Store parameters in list
    query_params = []
    # and do a counter to see how many placeholders while the query is built
    param_counter = 1
    query = f"""
        WITH DividendCount AS (
            SELECT ticker, COUNT(ticker) AS "numDividends", amount 
            FROM dividends 
            WHERE EXTRACT(YEAR FROM payment_date) = {this_year}
            GROUP BY ticker, amount
        ),
        FindExDate AS (
            SELECT ticker, MIN(declaration_date) AS "declarationDate"
            FROM dividends
            WHERE EXTRACT(YEAR FROM declaration_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    """
    if exDateMonth:
        query += f" AND EXTRACT(MONTH FROM declaration_date) = ${param_counter}"
        query_params.append(exDateMonth)
        param_counter += 1
    # Close cte
    query += " GROUP BY ticker) "
    query += """
        SELECT dd.ticker,
            dd.numDividends,
            dd.amount,
            f.declarationDate,
            m.sector, 
            m.market_cap, 
            m.pe_ratio, 
            m.forward_pe_1yr, 
            m.earnings_per_share, 
            m.annualized_dividend, 
            m.yield,
            ih.shares_outstanding_pct,
            NULLIF(ih.newpositionsholders, 0) / NULLIF(ih.soldoutpositionsholders, 0) as "ratioHoldersBuySold"
        FROM DividendCount dd
        JOIN FindExDate f ON f.ticker = dd.ticker
        JOIN metadata m ON m.ticker = dd.ticker
        JOIN institutional_holdings ih ON ih.ticker = dd.ticker
    """
    if numDividends is not None:
        query += f" AND dd.numDividends >= ${param_counter}"
        query_params.append(numDividends)
        param_counter += 1
    if amountAbove is not None:
        query += f" AND dd.amount >= ${param_counter}"
        query_params.append(amountAbove)
        param_counter += 1
    if sector is not None:
        query += f" AND m.sector >= ${param_counter}"
        query_params.append(sector)
        param_counter += 1
    if marketcap is not None:
        query += f" AND m.market_cap >= ${param_counter}"
        query_params.append(marketcap)
        param_counter += 1
    if peratio is not None:
        query += f" AND m.pe_ratio >= ${param_counter}"
        query_params.append(peratio)
        param_counter += 1

    if forwardpe1yr is not None:
        query += f" AND m.forward_pe_1yr >= ${param_counter}"
        query_params.append(forwardpe1yr)
        param_counter += 1
    if earningspershare is not None:
        query += f" AND m.earnings_pershare >= ${param_counter}"
        query_params.append(earningspershare)
        param_counter += 1
    if annualizeddividend is not None:
        query += f" AND m.annualized_dividend >= ${param_counter}"
        query_params.append(annualizeddividend)
        param_counter += 1
    if annualyield is not None:
        query += f" AND m.yield >= ${param_counter}"
        query_params.append(annualyield)
        param_counter += 1
    if sharesoutstandingpct is not None:
        query += f" AND m.shares_outstanding_pct >= ${param_counter}"
        query_params.append(sharesoutstandingpct)
        param_counter += 1
    if ratioholdersbuysold is not None:
        query += f" AND NULLIF(ih.new_positions_holders, 0) / NULLIF(ih.sold_out_positions_holders, 0) >= ${param_counter}"
        query_params.append(ratioholdersbuysold)
        param_counter += 1

    query += " ORDER BY dd.numDividends DESC LIMIT 10"
    results = await db.fetch(query, *query_params)
    print(query_params)
    return results


@router.get("/{ticker}")
async def get_stock_by_ticker(
    ticker: str,
    db: Database = Depends(get_db)
):
    print('ticker:', ticker)
    query = """
        with latest_institutional  as (
            SELECT ticker, shares_outstanding_pct, 
                NULLIF(new_positions_holders, 0) / NULLIF(sold_out_positions_holders, 0) as ratioHoldersBuySold
            FROM institutional_holdings
            WHERE ticker = ($1)
            ORDER BY inserted DESC
            LIMIT 1
        )
        SELECT t.company_name as "Name", is_nasdaq100 as "IsNasdaq100",
        m.exchange as "Exchange", m.sector as "Sector", m.industry as "Industry", 
        m.one_yr_target as "1yTarget", m.average_volume as "AverageVolume",
        m.fiftytwo_week_high_low as "52weekHighLow", m.market_cap as "MarketCap", 
        m.pe_ratio as "PE", m.forward_pe_1yr as "ForwardPE1yr", 
        m.earnings_per_share as "EarningsShare", m.annualized_dividend as "AnnualizedDividend", 
        m.yield as "Yield", l.shares_outstanding_pct as "OutstandingShares%", 
        l.ratioHoldersBuySold as "ratioHoldersBuySold"
        FROM metadata m
        LEFT JOIN latest_institutional  l ON l.ticker = m.ticker
        LEFT JOIN tickers t ON l.ticker=t.ticker
        WHERE m.ticker = ($1)
        ORDER BY m.inserted DESC LIMIT 1;
    """

    results = await db.fetchrow(query, ticker.upper())

    if not results:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Stock not found.")
    # shares_outstanding = get_current_outstanding_shares_ticker(ticker.upper())
    # print(shares_outstanding)
    # results['sharesOutstanding'] = shares_outstanding
    # remove ticker i dont want ite
    return results


# # stocks/"MAIN"
# @router.get("/{ticker}")
# async def get_stock_by_ticker(
#     ticker: str,
#     db: Database = Depends(get_db)
# ):
#     query = """
#         SELECT m.ticker, m.name, m.market_cap, m.country, m.sector, m.industry,
#             i.institutional_ownership_perc, i.increased_positions_holders, i.decreased_positions_holders, i.held_positions_holders,
#             i.total_institutional_holders, i.new_positions_holders, i.sold_out_positions_holders
#         FROM metadata m
#         INNER JOIN institutional_holdings i
#         ON m.ticker = i.ticker
#         WHERE m.ticker=($1);
#     """
#     print("Getting ticket data from: ",ticker)
#     # results = await db.fetch(query, ticker)
#     results = {
#         "ticker": "MAIN",
#         "name" : "MAin insustries",
#         "country": "EEUU",
#         "sector": "Finances",
#         "industry": "Services",
#         "institutional_ownership_perc": 40.3,
#         "increased_positions_holders": 20,
#         "decreased_positions_holders":5,
#         "held_positions_holders": 10,
#         "total_institutional_holders": 50,
#         "new_positions_holders":1,
#         "sold_out_positions_holders":0
#     }
#     return  results
