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
    companyName TEXT,
    stockType TEXT,
    exchange TEXT,
    assetClass TEXT,
    isNasdaqListed BOOLEAN,
    isNasdaq100 BOOLEAN,
    isHeld BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_ticker_tickers ON tickers (ticker);

CREATE TABLE IF NOT EXISTS metadata (
    id SERIAL PRIMARY KEY,
    ticker TEXT NOT NULL,
    exchange TEXT,
    sector TEXT,
    industry TEXT,
    oneYrTarget NUMERIC(12, 2),
    todayHighLow TEXT,
    shareVolume BIGINT,
    averageVolume BIGINT,
    previousClose NUMERIC(12,2),
    fiftTwoWeekHighLow TEXT,
    marketCap BIGINT,
    PERatio NUMERIC(12,2),
    forwardPE1Yr  NUMERIC(12,2),
    earningsPerShare  NUMERIC(12,2),
    annualizedDividend  NUMERIC(12,2),
    exDividendDate DATE,
    dividendPaymentDate DATE,
    yield  NUMERIC(12,2),
    specialDividendDate DATE,
    specialDividendAmount  NUMERIC(12,2),
    specialDividendPaymentDate DATE,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker)
);

CREATE INDEX IF NOT EXISTS idx_metadata_ticker ON metadata (ticker);

CREATE TABLE IF NOT EXISTS dividends (
    id SERIAL PRIMARY KEY,
    ticker TEXT NOT NULL,
    exOrEffDate DATE,
    paymentType TEXT,
    amount NUMERIC(12, 2),
    declarationDate DATE,
    recordDate DATE,
    paymentDate DATE,
    currency TEXT,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker),
    CONSTRAINT unique_ticker_dividend UNIQUE (ticker, exOrEffDate, paymentType, amount, declarationDate, recordDate, paymentDate, currency)
);

CREATE INDEX IF NOT EXISTS idx_dividends_ticker ON dividends (ticker);

CREATE TABLE IF NOT EXISTS institutional_holdings (
    id SERIAL PRIMARY KEY,
    ticker text NOT NULL,
    sharesOutstandingPCT NUMERIC(12,2),
    sharesOutstandingTotal BIGINT,
    totalHoldingsValue BIGINT,
    increasedPositionsHolders BIGINT,
    increasedPositionsShares BIGINT,
    decreasedPositionsHolders BIGINT,
    decreasedPositionsShares BIGINT,
    heldPositionsHolders BIGINT,
    heldPositionsShares BIGINT,
    totalPositionsHolders BIGINT,
    totalPositionsShares BIGINT,
    newPositionsHolders  BIGINT,
    newPositionsShares BIGINT,
    soldOutPositionsHolders BIGINT,
    soldOutPositionsShares BIGINT,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker)
);

CREATE INDEX IF NOT EXISTS idx_institutional_holdings_ticker ON institutional_holdings (ticker);

-- Relational tables
CREATE TABLE IF NOT EXISTS favorites (
    ticker text NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (ticker, user_id),
    FOREIGN KEY (ticker) REFERENCES tickers(ticker),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create Portfolio and its relations
CREATE TABLE IF NOT EXISTS portfolio (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    price NUMERIC(19, 2),
    quantity BIGINT,
    fee NUMERIC(19, 2) DEFAULT 2,
    -- Calculated column: price * quantity + fee
    totalValue NUMERIC(19, 2) GENERATED ALWAYS AS (price * quantity + fee) STORED, 
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
    transactionType TEXT,
    fee NUMERIC DEFAULT 0,
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
	AND transactionType='sell';

    RETURN QUERY SELECT total_funds, total_spent,total_gains;
END;
$BODY$;



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

	--cash
    SELECT COALESCE(SUM(amount), 0)
    INTO total_funds
    FROM funds
    WHERE user_id = user_id_input;

	-- positions
    SELECT COALESCE(sum(totalValue), 0)
	INTO total_spent
	FROM portfolio
	WHERE user_id = user_id_input;

	-- REalized gains
	SELECT COALESCE(SUM(amount), 0)
	INTO total_gains
	FROM funds
	WHERE user_id = user_id_input
	AND description LIKE  '%Sold%';

    RETURN QUERY SELECT total_funds, total_spent,total_gains;
END;
$BODY$;

