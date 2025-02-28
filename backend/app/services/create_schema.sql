--
-- You need to create the database journal_app manually
--

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR NOT NULL UNIQUE,
    email VARCHAR NOT NULL UNIQUE,
    password VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    user_id INT,
    title VARCHAR NOT NULL,
    content VARCHAR NOT NULL,
    published VARCHAR NOT NULL DEFAULT FALSE, 
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_post FOREIGN KEY(user_id) REFERENCES users(id)
);


CREATE TABLE IF NOT EXISTS votes (
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (post_id, user_id),
    CONSTRAINT fk_votes_posts FOREIGN KEY (post_id) REFERENCES posts(id),
    CONSTRAINT fk_votes_users FOREIGN KEY (user_id) REFERENCES users(id)
);

-- The data of the following tables are extracted from another database 
CREATE TABLE IF NOT EXISTS tickers (
    id SERIAL PRIMARY KEY,
    ticker TEXT UNIQUE NOT NULL,
    company_name TEXT,
    stock_type TEXT,
    exchange TEXT,
    asset_class TEXT,
    is_nasdaq_listed BOOLEAN,
    is_nasdaq100 BOOLEAN,
    is_held BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_ticker_tickers ON tickers (ticker);

CREATE TABLE IF NOT EXISTS metadata (
    id SERIAL PRIMARY KEY,
    ticker TEXT NOT NULL,
    exchange TEXT,
    sector TEXT,
    industry TEXT,
    one_yr_target NUMERIC(12, 2),
    today_high_low TEXT,
    share_volume BIGINT,
    average_volume BIGINT,
    previous_close NUMERIC(12,2),
    fiftytwo_week_high_low TEXT,
    market_cap BIGINT,
    pe_ratio NUMERIC(12,2),
    forward_pe_1yr  NUMERIC(12,2),
    earnings_per_share  NUMERIC(12,2),
    annualized_dividend  NUMERIC(12,2),
    ex_dividend_date DATE,
    dividend_payment_date DATE,
    yield  NUMERIC(12,2),
    special_dividend_date DATE,
    special_dividend_amount  NUMERIC(12,2),
    special_dividend_payment_date DATE,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker)
);

CREATE INDEX IF NOT EXISTS idx_metadata_ticker ON metadata (ticker);

CREATE TABLE IF NOT EXISTS dividends (
    id SERIAL PRIMARY KEY,
    ticker TEXT NOT NULL,
    ex_date DATE,
    payment_type TEXT,
    amount NUMERIC(12, 2),
    declaration_date DATE,
    record_date DATE,
    payment_date DATE,
    currency TEXT,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker),
    CONSTRAINT unique_ticker_dividend UNIQUE (ticker, ex_date, payment_type, amount, declaration_date, record_date, payment_date, currency)
);

CREATE INDEX IF NOT EXISTS idx_dividends_ticker ON dividends (ticker);

CREATE TABLE IF NOT EXISTS institutional_holdings (
    id SERIAL PRIMARY KEY,
    ticker text NOT NULL,
    shares_outstanding_pct NUMERIC(12,2),
    shares_outstanding_total BIGINT,
    total_holdings_value BIGINT,
    increased_positions_holders BIGINT,
    increased_positions_shares BIGINT,
    decreased_positions_holders BIGINT,
    decreased_positions_shares BIGINT,
    held_positions_holders BIGINT,
    held_positions_shares BIGINT,
    total_positions_holders BIGINT,
    total_positions_shares BIGINT,
    new_positions_holders  BIGINT,
    new_positions_shares BIGINT,
    sold_out_positions_holders BIGINT,
    sold_out_positions_shares BIGINT,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker)
);

CREATE INDEX IF NOT EXISTS idx_institutional_holdings_ticker ON institutional_holdings (ticker);

-- Create Portfolio and its relations
CREATE TABLE IF NOT EXISTS portfolio (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    price NUMERIC(19, 2),
    quantity BIGINT,
    fee NUMERIC(19, 2) DEFAULT 2,
    -- Calculated column: price * quantity + fee
    total_value NUMERIC(19, 2) GENERATED ALWAYS AS (price * quantity + fee) STORED, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, ticker, fee, created_at)
);
CREATE INDEX IF NOT EXISTS idx_portfolio_user_ticker ON portfolio (user_id, ticker);
CREATE INDEX IF NOT EXISTS idx_portfolio_fifo ON portfolio (user_id, ticker, fee, created_at);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY, 
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    price NUMERIC(19,2),
    quantity BIGINT,
    transaction_type TEXT,
    fee NUMERIC DEFAULT 0,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_transcations_user_ticker ON transactions (user_id, ticker);


CREATE TABLE IF NOT EXISTS funds (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    amount NUMERIC(19,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_funds_user ON funds (user_id);


CREATE TABLE dividend_transactions (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  ticker TEXT REFERENCES tickers(ticker),
  dividend NUMERIC,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_dividend_transactions_user_ticker ON dividend_transactions (user_id, ticker);

-- Create Some functions or porcedures we might need
CREATE OR REPLACE FUNCTION public.calculate_portfolio_totals(
	user_id_input integer)
    RETURNS TABLE(total_funds numeric, total_spent numeric, total_gains numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    total_funds NUMERIC;
    total_spent NUMERIC;
	total_gains NUMERIC;
BEGIN

    SELECT COALESCE(SUM(amount), 0)
    INTO total_funds
    FROM funds
    WHERE user_id = user_id_input;

    SELECT COALESCE(sum(totalValue), 0)
	INTO total_spent
	FROM portfolio
	WHERE user_id = 2	;

	SELECT COALESCE(SUM(price*quantity+fee), 0)
	INTO total_gains
	FROM transactions
	WHERE user_id = user_id_input
	AND transaction_type='sell';

    RETURN QUERY SELECT total_funds, total_spent,total_gains;
END;
$BODY$;



CREATE OR REPLACE FUNCTION get_portfolio_summary(user_id_input INTEGER)
RETURNS TABLE(
	ticker TEXT,
	"totalValue" NUMERIC,
	"totalQuantity" NUMERIC
)
LANGUAGE sql
AS $BODY$
WITH totals AS (
  SELECT
    COALESCE((SELECT SUM(amount) FROM funds WHERE user_id = user_id_input), 0) AS total_funds,
    COALESCE((SELECT SUM(total_value) FROM portfolio WHERE user_id = user_id_input), 0) AS total_spent
)
SELECT 
  ticker,
  SUM(total_value) AS "totalValue",
  SUM(quantity) AS "totalQuantity"
FROM public.portfolio
WHERE user_id = user_id_input
GROUP BY ticker

UNION ALL

SELECT
  'Money' AS ticker,
  (t.total_funds - t.total_spent) AS "totalValue",  
  NULL::numeric AS "totalQuantity"
FROM totals t;
$BODY$;


-- Add transaction
CREATE OR REPLACE FUNCTION public.add_transaction(
	user_id_input integer,
	ticker_input text,
	price_input numeric,
	quantity_input numeric,
	transaction_type_input text,
	fee_input numeric DEFAULT 2,
    details_input text default ''
    )
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    available_funds NUMERIC;
    return_message TEXT;
    ticker_exists BOOLEAN;
    total_transaction NUMERIC;
    total_quantity_stock NUMERIC;
	remaining_quantity NUMERIC; -- Placeholder to use in FIFO deletion
	record RECORD; -- record variable to hold the row data
BEGIN

    SELECT COALESCE(SUM(amount), 0)
    INTO available_funds
    FROM funds
    WHERE user_id = user_id_input;

    SELECT EXISTS (SELECT 1 FROM tickers WHERE ticker = ticker_input) INTO ticker_exists;

    IF ticker_exists THEN
        IF LOWER(transaction_type_input) = 'buy' THEN
			-- If you buy you pay the fee
			total_transaction := price_input * quantity_input + fee_input;
            IF available_funds >= total_transaction THEN
                -- If enough funds, buy, "insert ignore" if ticker not in portfolio 
                INSERT INTO portfolio (user_id, ticker, price, quantity, fee) 
                SELECT user_id_input, ticker_input, price_input, quantity_input, fee_input
                ;
				
                INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, details) 
                VALUES (user_id_input, ticker_input, price_input, quantity_input, transaction_type_input, fee_input, details_input);
                -- Add the fund 'transaction' in order to keep record of the funds, total transaction in negative!
				INSERT INTO funds (user_id, amount, description) 
                VALUES (user_id_input, -total_transaction, 'Bought ' || quantity_input || ' of ' || ticker_input || ' at ' || price_input);
				return_message := 'Transaction BUY added successfully.';
            ELSE
                return_message := 'Insufficient funds.';
            END IF;
        ELSIF LOWER(transaction_type_input) = 'sell' THEN
            SELECT SUM(quantity) INTO total_quantity_stock FROM transactions WHERE user_id = user_id_input AND ticker = ticker_input;
            -- If you sell the fee is negative
			total_transaction := price_input * quantity_input - fee_input;
			IF total_quantity_stock >= quantity_input THEN
			    -- Quantity must be negative
                INSERT INTO transactions (user_id, ticker, price, quantity, transactionType, fee, details) 
                VALUES (user_id_input, ticker_input, price_input, quantity_input, transaction_type_input, fee_input, details_input);
                
				-- DELETE ticker in portfolio in FIFO
                remaining_quantity := quantity_input;
				FOR record IN 
					SELECT price, quantity, fee, created_at
					FROM portfolio
					WHERE user_id = user_id_input AND ticker = ticker_input
					ORDER BY created_at
					FOR UPDATE SKIP LOCKED
				LOOP
					-- If the current quantity is less than or equal to the remaining quantity to sell, remove the whole row
					IF record.quantity <= remaining_quantity THEN
						DELETE FROM portfolio
						WHERE user_id = user_id_input AND ticker = ticker_input
						AND price = record.price AND fee = record.fee AND created_at= record.created_at;
						-- Decrease the remaining quantity to sell
                        remaining_quantity := remaining_quantity - record.quantity;
					-- If the current quantity is more than the remaining quantity to sell, update the quantity
					ELSE
						UPDATE portfolio
						SET quantity = record.quantity - remaining_quantity
						WHERE user_id = user_id_input AND ticker = ticker_input
						AND price =record.price AND fee = record.fee AND created_at = record.created_at;
						remaining_quantity := 0;
					END IF;
					-- Exit the loop if the remaining quantity to sell has been fulfilled
                    IF remaining_quantity = 0 THEN
                        EXIT;
                    END IF;
                END LOOP;
				-- Add the the sell, quantity is positive!
 				INSERT INTO funds (user_id, amount, description) 
                VALUES (user_id_input, total_transaction, 'Sold ' || quantity_input || ' of ' || ticker_input || ' at ' || price_input);
                return_message := 'Transaction SELL added successfully.';
            ELSE
                return_message := 'There is not enough stock to sell.';
            END IF;
        ELSE
            return_message := 'Invalid transaction type.';
        END IF;
    ELSE
        return_message := 'Ticker does not exist.';
    END IF;

    RETURN return_message;
END;
$BODY$;