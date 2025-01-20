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
    name TEXT
);

CREATE INDEX IF NOT EXISTS idx_ticker_tickers ON tickers (ticker);


CREATE TABLE IF NOT EXISTS metadata (
    id SERIAL PRIMARY KEY,
    ticker TEXT NOT NULL,
    name TEXT,
    last_sale NUMERIC(12, 2),
    net_change NUMERIC(12, 2),
    change_perc NUMERIC(12, 2),
    market_cap BIGINT,
    country TEXT,
    ipo_year BIGINT,
    volume BIGINT,
    sector TEXT,
    industry TEXT,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker)
);

CREATE INDEX IF NOT EXISTS idx_metadata_ticker ON metadata (ticker);

CREATE TABLE IF NOT EXISTS dividends (
    id SERIAL PRIMARY KEY,
    ticker TEXT NOT NULL,
    ex_dividend_date DATE,
    payment_type TEXT,
    amount NUMERIC(12, 2),
    declaration_date DATE,
    record_date DATE,
    payment_date DATE,
    currency TEXT,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker),
    CONSTRAINT unique_ticker_ex_dividend_date_declaration_date UNIQUE (ticker, ex_dividend_date, declaration_date)
);

CREATE INDEX IF NOT EXISTS idx_dividends_ticker ON dividends (ticker);

CREATE TABLE IF NOT EXISTS institutional_holdings (
    id SERIAL PRIMARY KEY,
    ticker text NOT NULL,
    institutional_ownership_perc NUMERIC,
    total_shares_outstanding_millions NUMERIC,
    total_value_holdings_millions NUMERIC,
    increased_positions_holders NUMERIC,
    increased_positions_shares NUMERIC,
    decreased_positions_holders NUMERIC,
    decreased_positions_shares NUMERIC,
    held_positions_holders NUMERIC,
    held_positions_shares NUMERIC,
    total_institutional_holders NUMERIC,
    total_institutional_shares NUMERIC,
    new_positions_holders NUMERIC,
    new_positions_shares NUMERIC,
    sold_out_positions_holders NUMERIC,
    sold_out_positions_shares NUMERIC,
    refreshed_page_date TIMESTAMP DEFAULT NULL,
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticker) REFERENCES tickers (ticker)
);

CREATE INDEX IF NOT EXISTS idx_institutional_holdings_ticker ON institutional_holdings (ticker);


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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, ticker)
);
CREATE INDEX IF NOT EXISTS idx_portfolio_user_ticker ON portfolio (user_id, ticker);


CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY, 
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    price NUMERIC,
    quantity INT,
    transaction_type TEXT,
    fee NUMERIC DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_transcations_user_ticker ON transactions (user_id, ticker);


CREATE TABLE IF NOT EXISTS funds (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    amount NUMERIC,
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
CREATE OR REPLACE FUNCTION calculate_portfolio_totals(
    user_id_input INT
)
RETURNS TABLE(
    total_funds NUMERIC,
    total_spent NUMERIC,
    available_funds NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COALESCE(SUM(amount), 0),
           COALESCE(SUM(price * quantity + fee), 0),
           COALESCE(SUM(amount), 0) - COALESCE(SUM(price * quantity + fee), 0)
    INTO total_funds, total_spent, available_funds
    FROM funds
    LEFT JOIN transactions ON funds.user_id = transactions.user_id
    WHERE funds.user_id = user_id_input;
    RETURN NEXT;
END;
$$;