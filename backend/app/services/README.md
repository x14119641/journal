# Database needs 
In order to call the sync_nsdq_data but first you need the "dblink"
```
CREATE EXTENSION dblink;
SELECT dblink_connect('myconn', 'dbname=mydb user=myuser password=mypass host=localhost');
CALL sync_nsdq_data();
```

# sync_nsdq_data
Is basically a fetcher, iterates on the tables of nsdq database and exports only the data that does not exist in journal database.
This script is local due passwords. Looks like this though:
```
CREATE OR REPLACE PROCEDURE public.sync_nsdq_data(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    tickers_last_id integer;
	tickers_inserted integer;
	dividends_last_id integer;
	dividends_inserted integer;
	metadata_last_id integer;
	metadata_inserted integer;
	institutionals_last_id integer;
	institutionals_inserted integer;
BEGIN
	-- Tickers
    SELECT COALESCE(MAX(id), 0) INTO tickers_last_id FROM tickers LIMIT 1;

    INSERT INTO tickers(id, ticker, company_name, stock_type, exchange, asset_class, is_nasdaq_listed, is_nasdaq100, is_held)
    SELECT id, ticker, company_name, stock_type, exchange, asset_class, is_nasdaq_listed, is_nasdaq100, is_held
    FROM dblink('dbname=nsdq user=YOUR_USER password=YOUR_PWD',
                'SELECT id, ticker, company_name, stock_type, exchange, asset_class, is_nasdaq_listed, is_nasdaq100, is_held FROM tickers WHERE id > ' || tickers_last_id)
    AS nsdq_data(id INTEGER, ticker TEXT, company_name TEXT, stock_type TEXT, exchange TEXT, asset_class TEXT, is_nasdaq_listed BOOLEAN, is_nasdaq100 BOOLEAN, is_held BOOLEAN);

	GET DIAGNOSTICS tickers_inserted = ROW_COUNT;

	RAISE NOTICE '% rows inserted into tickers.', tickers_inserted;

	-- Dividends
    SELECT COALESCE(MAX(id), 0) INTO dividends_last_id FROM dividends;

    INSERT INTO dividends(id, ticker, ex_date, payment_type, amount, declaration_date, record_date, payment_date, currency, inserted)
    SELECT id, ticker, ex_date, payment_type, amount, declaration_date, record_date, payment_date, currency, inserted
    FROM dblink('dbname=nsdq user=YOUR_USER password=YOUR_PWD',
                'SELECT id, ticker, ex_date, payment_type, amount, declaration_date, record_date, payment_date, currency, inserted FROM dividends WHERE id > ' || dividends_last_id)
    AS nsdq_data(id INTEGER, ticker TEXT, ex_date DATE, payment_type TEXT, amount NUMERIC(12,2), 
				declaration_date DATE, record_date DATE, payment_date DATE, currency TEXT, inserted TIMESTAMP);

    GET DIAGNOSTICS dividends_inserted = ROW_COUNT;

    RAISE NOTICE '% rows inserted into dividends.', dividends_inserted;
	
	-- Metadata
	SELECT COALESCE(MAX(id), 0) INTO metadata_last_id FROM metadata;
	INSERT INTO metadata (id, ticker, exchange, sector, industry, one_yr_target, today_high_low, share_volume, 
							average_volume, previous_close, fiftytwo_week_high_low, market_cap, pe_ratio, 
							forward_pe_1yr, earnings_per_share, annualized_dividend, ex_dividend_date, 
							dividend_payment_date, yield, special_dividend_date, special_dividend_amount, 
							special_dividend_payment_date, inserted)
		SELECT id, ticker, exchange, sector, industry, one_yr_target, today_high_low, share_volume, 
			  average_volume, previous_close, fiftytwo_week_high_low, market_cap, pe_ratio, 
			  forward_pe_1yr, earnings_per_share, annualized_dividend, ex_dividend_date, 
			  dividend_payment_date, yield, special_dividend_date, special_dividend_amount, 
			  special_dividend_payment_date, inserted
		FROM dblink('dbname=nsdq user=YOUR_USER password=YOUR_PWD',
			'SELECT id, ticker, exchange, sector, industry, one_yr_target, today_high_low, share_volume, 
						average_volume, previous_close, fiftytwo_week_high_low, market_cap, pe_ratio, 
						forward_pe_1yr, earnings_per_share, annualized_dividend, ex_dividend_date, 
						dividend_payment_date, yield, special_dividend_date, special_dividend_amount, 
						special_dividend_payment_date, inserted 
				  FROM metadata WHERE id > ' || metadata_last_id)
		AS nsdq_data(id INTEGER, ticker TEXT, exchange TEXT, sector TEXT, industry TEXT, one_yr_target NUMERIC(12, 2), 
					today_high_low TEXT, share_volume BIGINT, average_volume BIGINT, previous_close NUMERIC(12, 2), 
					fiftytwo_week_high_low TEXT, market_cap BIGINT, pe_ratio NUMERIC(12, 2), forward_pe_1yr NUMERIC(12, 2), 
					earnings_per_share NUMERIC(12, 2), annualized_dividend NUMERIC(12, 2), ex_dividend_date DATE, dividend_payment_date DATE, 
					yield NUMERIC(12, 2), special_dividend_date DATE, special_dividend_amount NUMERIC(12, 2), 
					special_dividend_payment_date DATE, inserted TIMESTAMP);
	GET DIAGNOSTICS metadata_inserted = ROW_COUNT;

	RAISE NOTICE '% rows inserted into metadata.', metadata_inserted;
	
	-- Institutional
	SELECT COALESCE(MAX(id), 0) INTO institutionals_last_id FROM institutional_holdings;
	INSERT INTO institutional_holdings (id, ticker, shares_outstanding_pct, shares_outstanding_total, 
										total_holdings_value, increased_positions_holders, increased_positions_shares, 
										decreased_positions_holders, decreased_positions_shares, held_positions_holders, 
										held_positions_shares, total_positions_holders, total_positions_shares, 
										new_positions_holders, new_positions_shares, sold_out_positions_holders, 
										sold_out_positions_shares, inserted)
		SELECT id, ticker, shares_outstanding_pct, shares_outstanding_total, 
										total_holdings_value, increased_positions_holders, increased_positions_shares, 
										decreased_positions_holders, decreased_positions_shares, held_positions_holders, 
										held_positions_shares, total_positions_holders, total_positions_shares, 
										new_positions_holders, new_positions_shares, sold_out_positions_holders, 
										sold_out_positions_shares, inserted
		FROM dblink('dbname=nsdq user=YOUR_USER password=YOUR_PWD',
			'SELECT id, ticker, shares_outstanding_pct, shares_outstanding_total, 
										total_holdings_value, increased_positions_holders, increased_positions_shares, 
										decreased_positions_holders, decreased_positions_shares, held_positions_holders, 
										held_positions_shares, total_positions_holders, total_positions_shares, 
										new_positions_holders, new_positions_shares, sold_out_positions_holders, 
										sold_out_positions_shares, inserted 
										FROM institutional_holdings WHERE id > ' || institutionals_last_id)
		AS nsdq_data(id INTEGER, ticker TEXT, shares_outstanding_pct NUMERIC(12,2), shares_outstanding_total BIGINT, 
					total_holdings_value BIGINT, increased_positions_holders BIGINT, increased_positions_shares BIGINT, 
					decreased_positions_holders BIGINT, decreased_positions_shares BIGINT, held_positions_holders BIGINT, 
					held_positions_shares BIGINT, total_positions_holders BIGINT, total_positions_shares BIGINT, 
					new_positions_holders BIGINT, new_positions_shares BIGINT, sold_out_positions_holders BIGINT, 
					sold_out_positions_shares BIGINT, inserted TIMESTAMP);
	GET DIAGNOSTICS institutionals_inserted = ROW_COUNT;

	RAISE NOTICE '% rows inserted into Institiotionals.', institutionals_inserted;
END;
$BODY$;
```

