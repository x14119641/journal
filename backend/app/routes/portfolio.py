from ..dependencies import get_db
from ..services.database import Database
from ..services import mini_scarper
from ..schema import UserLogin, BacktestRequest
from .auth import get_current_active_user
from fastapi import Depends, Response, status, APIRouter, HTTPException
from typing import Annotated, List
from decimal import Decimal
from datetime import datetime


router = APIRouter(
    prefix="/portfolio",
    tags=[
        "Portfolio",
    ],
)


@router.get("/get_balance")
async def get_balance(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    current_balance = await db.fetchone("SELECT get_balance(($1))", current_user.id)
    print("Balance:", current_balance)
    return {"value": current_balance or 0}


@router.get("/balance/history")
async def get_balance_history(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetch(
        """
                             SELECT balance, 
                                TO_CHAR(recorded_at, 'YYYY-MM-DD') as recorded_at
                             FROM balance_history 
                             WHERE user_id = $1
                             ORDER BY recorded_at;""",
        current_user.id,
    )
    # faking data
    # results = [
    #   { 'record_date': "2024-01-01", 'balance': 5000.0 },
    #   { 'record_date': "2024-02-01", 'balance': 5200.5 },
    #   { 'record_date': "2024-03-01", 'balance': 5400.75 },
    #   { 'record_date': "2024-04-01", 'balance': 5300.2 },
    #   { 'record_date': "2024-05-01", 'balance': 5600.8 },
    #   { 'record_date': "2024-06-01", 'balance': 5900.3 },
    # ]
    results = [
        {
            "recorded_at": row["recorded_at"],
            "balance": float(row["balance"]),
        }
        for row in results
    ]
    print(results)
    return results


@router.get("/get_portfolio")
async def get_portfolio(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetch("SELECT * FROM get_portfolio(($1))", current_user.id)

    if not results:
        raise HTTPException(
            status_code=status.HTTP_204_NO_CONTENT, detail="Portfolio is empty"
        )

    return results


@router.get("/get_total_fees")
async def get_total_fees(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetchone("SELECT * FROM get_total_fees(($1))", current_user.id)
    # print(results)
    # if not results:
    #     raise HTTPException(status_code=status.HTTP_204_NO_CONTENT,
    #                             detail="Noo fees")
    return {"value": results}


@router.get("/get_total_money_invested")
async def get_total_money_invested(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    money_invested = await db.fetchone(
        "SELECT get_total_money_invested(($1))", current_user.id
    )
    # print(money_invested)
    return {"value": money_invested}


@router.get("/get_total_money_earned")
async def get_total_money_earned(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    money_earned = await db.fetchone(
        "SELECT get_total_money_earned(($1))", current_user.id
    )
    # print(money_invested)
    return {"value": money_earned}


@router.get("/get_current_portfolio_value")
async def get_current_portfolio_value(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    current_portfolio_value = await db.fetchone(
        "SELECT get_current_portfolio_value(($1))", current_user.id
    )
    # print(current_portfolio_value)
    return {"value": current_portfolio_value}


@router.get("/get_net_profit_loss")
async def get_net_profit_loss(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    net_profit_loss = await db.fetchone(
        "SELECT get_net_profit_loss(($1))", current_user.id
    )
    # print(net_profit_loss)
    return {"value": net_profit_loss}


@router.get("/ticker/{ticker}")
async def get_ticker_portfolio_summary(
    ticker: str,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetchrow(
        "SELECT * FROM get_ticker_portfolio_summary($1, $2)", current_user.id, ticker
    )

    if not results:
        raise HTTPException(
            status_code=status.HTTP_204_NO_CONTENT, detail="Ticker not in Portfolio"
        )

    return results


@router.get("/get_monthly_performance/{month}/{year}")
async def get_monthly_performance(
    month: int,
    year: int,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetchrow(
        """
                             SELECT * FROM get_monthly_performance(($1), ($2), ($3))""",
        current_user.id,
        month,
        year,
    )

    return results


@router.get("/dividend/monthly")
async def get_dividend_monthly(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetch(
        """
                            SELECT extract(month from payment_date) as monthIndex,sum(estimated_payout) as "estimatedPayout"
                            FROM user_dividends where user_id=$1 GROUP BY 1;
                            """,
        current_user.id,
    )
    # print('results: ', results)
    return results


@router.get("/dividend/monthly/grouped")
async def get_dividend_monthly_grouped(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetch(
        """
                            SELECT 
                                EXTRACT(MONTH FROM payment_date) AS month, 
                                ticker, 
                                SUM(estimated_payout) AS amount
                            FROM user_dividends
                            WHERE user_id = $1
                            GROUP BY month, ticker
                            ORDER BY month, ticker;
                            """,
        current_user.id,
    )
    print('results: ', results)
    return results


@router.get("/dividend/monthly/profitloss")
async def get_dividend_monthly_realized_profit_loss(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetch(
        """
                            WITH x AS (
                                SELECT 
                                    EXTRACT(MONTH FROM payment_date) AS monthIndex, 

                                    SUM(estimated_payout) AS realizedProfitLoss
                                FROM user_dividends
                                WHERE user_id = $1
                                AND is_executed = TRUE
                                GROUP BY 1
                            ),
                            y AS (
                                SELECT 
                                    EXTRACT(MONTH FROM created_at) AS monthIndex,
                                    SUM(realized_profit_loss) AS realizedProfitLoss
                                FROM transactions
                                WHERE user_id = $2
                                AND transaction_type NOT IN ('DIVIDEND', 'DEPOSIT', 'WITHDRAW')
                                GROUP BY 1
                            )

                            SELECT 
                                COALESCE(x.monthIndex, y.monthIndex) AS "monthIndex",
                                COALESCE(x.realizedProfitLoss, 0) + COALESCE(y.realizedProfitLoss, 0) AS "totalRealizedProfitLoss"
                            FROM x
                            FULL OUTER JOIN y 
                            ON x.monthIndex = y.monthIndex 
                            ORDER BY 1, 2;

                            """,
        current_user.id,
        current_user.id,
    )
    # print('results5: ', results)
    return results


@router.get("/summary")
async def get_summary(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    summary = await db.fetch(
        """SELECT 
                p.ticker,
                ROUND(COALESCE(SUM(p.remaining_quantity), 0), 6) AS "remainingQuantity",
                ROUND(COALESCE(SUM(p.remaining_quantity * p.buy_price), 0), 6) AS "totalValue",
                ROUND(COALESCE(MIN(p.buy_price), 0), 6) AS "minPrice",
                ROUND(COALESCE(MAX(p.buy_price), 0), 6) AS "maxPrice",
                -- Weighted average buy price
                ROUND(COALESCE(
                    CASE 
                        WHEN COUNT(*) = 1 THEN MAX(p.buy_price) -- If one transaction, take that price
                        ELSE SUM(p.buy_price * p.remaining_quantity) / NULLIF(SUM(p.remaining_quantity), 0)
                    END, 0), 6) AS "avgBuyPrice",
                -- Breakeven price
                ROUND(COALESCE((SUM(p.buy_price * p.remaining_quantity) + SUM(p.fee)) / NULLIF(SUM(p.remaining_quantity), 0), 0), 6) AS "breakeven",
                ROUND(COALESCE(SUM(p.fee), 0), 6) AS "totalFees"
            FROM portfolio_lots p
            WHERE p.user_id = ($1)
            GROUP BY p.ticker;""",
        current_user.id,
    )
    # print("summary: ", summary)
    if summary is None:
        return []
    return summary


@router.get("/get_unrealized_money")
async def get_unrealized_money(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    net_profit_loss = await db.fetchone(
        "SELECT get_unrealized_money(($1))", current_user.id
    )
    # print(net_profit_loss)
    return {"value": net_profit_loss}


@router.post("/backtesting")
async def custom_backtesting(
    request: BacktestRequest,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    tickers = {
        asset.stock
        for portfolio in request.portfolios.values()
        for asset in portfolio
    }
    
    start_date = datetime.strptime(request.start_date, "%Y-%m-%d").date()
    end_date = datetime.strptime(request.end_date, "%Y-%m-%d").date()

    query = """
        SELECT ticker, ex_date, payment_date, amount
        FROM dividends
        WHERE ticker = ANY($1)
            AND ex_date BETWEEN $2 AND $3
        ORDER BY ticker, ex_date
    """
    rows = await db.fetch(query, list(tickers), start_date, end_date)
    print(rows)
    return 1


# @router.get("/summary")
# async def get_summary_external(
#         current_user: Annotated[UserLogin, Depends(get_current_active_user)],
#         db: Database = Depends(get_db)):
#     results = await db.fetch(
#         "SELECT * FROM get_portfolio_summary(($1))",
#         current_user.id)
#     tickers = [item['ticker'] for item in results if item['ticker'] != 'Money']

#     # Get current prices for the tickers
#     stocks = mini_scarper.get_current_price_tickers(tickers)

#     # Build a dictionary mapping ticker to price (only include those with a valid price)
#     price_map = {stock['ticker']: stock['price'] for stock in stocks if stock['price'] is not None}

#     clean_result = []

#     for row in results:
#         ticker = row.get('ticker')
#         # Skip if ticker is 'Money' or missing from our price_map
#         if ticker and ticker in price_map:
#             # Ensure that totalQuantity is valid and convert to Decimal if necessary
#             quantity = row.get('totalQuantity')
#             if quantity is not None:
#                 try:
#                     # Calculate market value: price * quantity
#                     row["marketValue"] = Decimal(price_map[ticker]) * Decimal(quantity)
#                     clean_result.append(row)
#                 except Exception as e:
#                     print(f"Error calculating market value for ticker {ticker}: {e}")
#             else:
#                 print(f"No totalQuantity for ticker {ticker}")
#         else:
#             if ticker not in price_map:
#                 print(f"Price not found for ticker {ticker} (or price is None).")
#     return clean_result


@router.get("/allocation/sector")
async def get_allocation_funds(
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Database = Depends(get_db),
):
    results = await db.fetch(
        """
                            with cte as (
                                SELECT ticker,
                                SUM(remaining_quantity) AS quantity 
                                FROM portfolio_lots 
                                WHERE user_id = ($1)
                                GROUP BY ticker
                            )
                            SELECT 
                            c.ticker,
                            c.quantity,
                            m.sector,
                            m.industry
                            FROM metadata m
                            JOIN cte c
                            ON c.ticker = m.ticker;
                            """,
        current_user.id,
    )
    if results is None:
        return []
    return results


# @router.get("/allocation/inital_cost")
# async def get_portfolio_barchart_data(
#         current_user: Annotated[UserLogin, Depends(get_current_active_user)],
#         db: Database = Depends(get_db)):
#     results = await db.fetch(
#         """SELECT ticker, SUM(total_value) AS "totalValue"
#             FROM portfolio
#             WHERE user_id = ($1)
#             GROUP BY ticker;""",
#         current_user.id)
#     return results


# @router.get("/funds/totals")
# async def get_total_funds(current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
#     """HEre we are supposed to get the following values:
#     total_funds: avalaible funds to invest. I guess i will change the name too
#     total_spent: amount invested right now (not as market), I guess i will change that too
#     total_gains: realized gains (i think i will change the name)
#     """
#     results = await db.fetchrow("""
#                                 SELECT * FROM calculate_portfolio_totals(($1))""",
#                                 current_user.id)
#     return results


# @router.post("/funds/add", status_code=status.HTTP_201_CREATED)
# async def add_funds(amount: int,
#                     current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
#     # print(amount)
#     results = await db.fetchrow("""
#                              INSERT INTO funds(user_id, amount, description)
#                              VALUES (($1), ($2), 'Deposit') RETURNING * """, current_user.id, amount)
#     print('RESULTS money: ', results)
#     return results


# @router.post("/funds/withdraw", status_code=status.HTTP_201_CREATED)
# async def withdraw_funds(amount: int,
#                     current_user: Annotated[UserLogin, Depends(get_current_active_user)], db: Database = Depends(get_db)):
#     portfolio = await db.fetchrow(
#         "SELECT * FROM calculate_portfolio_totals(($1))", current_user.id)
#     if portfolio:
#         if amount > portfolio["total_funds"]:
#             print('Not enough funds')
#             raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
#                                 detail="Not enough funds")
#     results = await db.fetchrow("""INSERT INTO funds(user_id, amount, description)
#                              VALUES (($1), ($2), 'Withdraw') RETURNING *""",
#                              current_user.id, -amount)
#     return results
