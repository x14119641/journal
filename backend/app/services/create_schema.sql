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
