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

-- Create Balance, I think we will need it
CREATE TABLE IF NOT EXISTS balance (
    user_id INT PRIMARY KEY REFERENCES users(id),
    total_balance NUMERIC(19,6) DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_balance_user_id ON balance (user_id);

-- Stores buy/sell transactions
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY, 
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    price NUMERIC(19,6),
    quantity NUMERIC(19,6),
    transaction_type TEXT,
    fee NUMERIC DEFAULT 0,
	realized_profit_loss NUMERIC(19,6) DEFAULT 0,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_transcations_user_ticker ON transactions (user_id, ticker);

-- Create a balance history
CREATE TABLE IF NOT EXISTS balance_history (
	id serial PRIMARY KEY,
	user_id INT REFERENCES users(id),
	change_amount NUMERIC(19, 2),
    new_balance NUMERIC(19,6),
	reason TEXT,
	transaction_id INT REFERENCES transactions(id) ON DELETE SET NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_balance_history_user_id ON balance_history (user_id);

-- Create Portfolio and its relations
CREATE TABLE IF NOT EXISTS portfolio_lots (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    buy_price NUMERIC(19, 2),
    quantity NUMERIC(19, 2),
	remaining_quantity NUMERIC(19, 2),
    fee NUMERIC(19, 2) DEFAULT 2,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_portfolio_lots_user_ticker ON portfolio_lots (user_id, ticker);




-- HEre will store the "deposits" withraws" or something that extracts or puts money in it the deposi
-- We dont need it anymore because we store everything in ransactions, balance and balance_history
-- CREATE TABLE IF NOT EXISTS funds (
--     id SERIAL PRIMARY KEY,
--     user_id INT REFERENCES users(id),
--     amount NUMERIC(19,6),
-- 	fund_type TEXT,
--     description TEXT,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );
-- CREATE INDEX IF NOT EXISTS idx_funds_user ON funds (user_id);

-- I guess I will need to store the fees
CREATE TABLE IF NOT EXISTS fees (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    ticker TEXT REFERENCES tickers(ticker),
    transaction_id INT REFERENCES transactions(id) ON DELETE CASCADE,
    type TEXT,
    fee NUMERIC(19,6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION buy_stock(
	_user_id INT,
	_ticker TEXT,
	_buy_price NUMERIC(19,6),
	_quantity NUMERIC(19,6),
	_fee NUMERIC(19,6)
) RETURNS TEXT LANGUAGE 'plpgsql' AS $$

DECLARE
	_total_cost NUMERIC(19,6);
	_current_balance NUMERIC(19,6);
	_new_balance NUMERIC(19,6);
BEGIN 
    --Check if ticker exists in the database
    IF NOT EXISTS (SELECT 1 FROM tickers WHERE ticker=_ticker) THEN
		RAISE EXCEPTION 'Ticker not in db';
	END IF;

	-- Calculate total cost of the purchase
	_total_cost := (_buy_price * _quantity) + _fee;

	-- Get current balance
	SELECT total_balance INTO _current_balance 
	FROM balance WHERE user_id = _user_id;

	-- Ensure sufficient funds
	IF _current_balance < _total_cost THEN
		RAISE EXCEPTION 'Insufficient funds';
	END IF;

	-- Insert transaction record for the buy action
	INSERT INTO transactions(user_id, ticker, price, quantity, transaction_type, fee, created_at)
	VALUES(_user_id, _ticker, _buy_price, _quantity, 'BUY', _fee, NOW());

	-- Insert into portfolio (FIFO tracking)
	INSERT INTO portfolio_lots(user_id, ticker, buy_price, quantity, remaining_quantity, fee, created_at)
	VALUES(_user_id, _ticker, _buy_price, _quantity, _quantity, _fee, NOW());

	-- Subtract the cost from the balance
	_new_balance := _current_balance - _total_cost;
	UPDATE balance SET total_balance = _new_balance WHERE user_id = _user_id;

	-- ✅ Insert transaction into balance history
	INSERT INTO balance_history (user_id, change_amount, new_balance, reason, created_at)
	VALUES (_user_id, -_total_cost, _new_balance, 'BUY', NOW());

	RETURN 'Stock purchased';
END;
$$;

CREATE OR REPLACE FUNCTION sell_stock(
    _user_id INT,
    _ticker TEXT,
    _price NUMERIC(19,6),  
    _quantity NUMERIC(19,6),  
    _fee NUMERIC(19,6)
) RETURNS TEXT LANGUAGE plpgsql AS $$

DECLARE
    _lot RECORD;
    _total_sell_value NUMERIC(19,6) := 0;
    _total_cost_basis NUMERIC(19,6) := 0;
    _total_allocated_fee NUMERIC(19,6) := 0;
    _profit_loss NUMERIC(19,6) := 0;
    _current_balance NUMERIC(19,6);
    _new_balance NUMERIC(19,6);
    _quantity_sold NUMERIC(19,6) := 0;
    _transaction_id INT;
    _remaining_to_sell NUMERIC(19,6) := _quantity;
BEGIN
    -- Check if ticker exists
    IF NOT EXISTS (SELECT 1 FROM tickers WHERE ticker = _ticker) THEN
        RAISE EXCEPTION 'Ticker not in db';
    END IF;

    -- Check if shares exist
    IF NOT EXISTS (SELECT 1 FROM portfolio_lots WHERE user_id = _user_id AND ticker = _ticker AND remaining_quantity > 0) THEN
        RAISE EXCEPTION 'No shares available to sell';
    END IF;

    -- Process FIFO sales
    WHILE _remaining_to_sell > 0 LOOP
        -- Get the oldest available lot
        SELECT * INTO _lot FROM portfolio_lots
        WHERE user_id = _user_id 
          AND ticker = _ticker 
          AND remaining_quantity > 0
        ORDER BY created_at ASC
        LIMIT 1;

        -- Check if a lot exists
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Not enough shares to sell';
        END IF;

        -- Determine quantity to sell
        IF _lot.remaining_quantity <= _remaining_to_sell THEN
            -- Selling entire lot
            _quantity_sold := _lot.remaining_quantity;
            _remaining_to_sell := _remaining_to_sell - _quantity_sold;
            _total_allocated_fee := _total_allocated_fee + _lot.fee; -- Full fee

            -- Calculate profit/loss
            _total_sell_value := _total_sell_value + (_price * _quantity_sold);
            _total_cost_basis := _total_cost_basis + (_lot.buy_price * _quantity_sold);

            -- Delete fully sold lot
            DELETE FROM portfolio_lots WHERE id = _lot.id;
        ELSE
            -- Selling partial lot
            _quantity_sold := _remaining_to_sell;
            _remaining_to_sell := 0;

            -- Calculate proportional fee allocation
            _total_allocated_fee := _total_allocated_fee + ((_quantity_sold / _lot.quantity) * _lot.fee);

            -- Calculate profit/loss
            _total_sell_value := _total_sell_value + (_price * _quantity_sold);
            _total_cost_basis := _total_cost_basis + (_lot.buy_price * _quantity_sold);

            -- Update lot
            UPDATE portfolio_lots 
            SET remaining_quantity = remaining_quantity - _quantity_sold, 
                fee = fee - ((_quantity_sold / _lot.quantity) * _lot.fee)
            WHERE id = _lot.id;
        END IF;
    END LOOP;

    -- Calculate final profit/loss
    _profit_loss := (_total_sell_value - _total_cost_basis - _total_allocated_fee);

    -- Insert transaction record
    INSERT INTO transactions(user_id, ticker, price, quantity, transaction_type, fee, realized_profit_loss, created_at)
    VALUES (_user_id, _ticker, _price, _quantity, 'SELL', _total_allocated_fee, _profit_loss, NOW())
    RETURNING id INTO _transaction_id;

    -- Update balance
    SELECT total_balance INTO _current_balance FROM balance WHERE user_id = _user_id;
    _new_balance := _current_balance + _total_sell_value;

    UPDATE balance 
    SET total_balance = _new_balance
    WHERE user_id = _user_id;

    -- Insert into balance history
    INSERT INTO balance_history (user_id, change_amount, new_balance, reason, transaction_id, created_at)
    VALUES (_user_id, _total_sell_value, _new_balance, 'SELL', _transaction_id, NOW());

    -- Return success message
    RETURN FORMAT('Success: Sold %s shares of %s. Profit/Loss: %s', _quantity, _ticker, _profit_loss);
END;
$$;



CREATE OR REPLACE PROCEDURE deposit_funds(
    IN _user_id INT,
    IN _amount NUMERIC(19,6),
    IN _description TEXT
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    -- Ensure the amount is positive
    IF _amount <= 0 THEN
        RAISE EXCEPTION 'Deposit amount must be positive';
    END IF;

    -- If the user has no balance record, insert a new one
    INSERT INTO balance (user_id, total_balance)
    VALUES (_user_id, _amount)
    ON CONFLICT (user_id) -- If user_id already exists, do nothing
    DO UPDATE SET total_balance = balance.total_balance + _amount;

    -- Insert transaction record for deposit
    INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, details, created_at)
    VALUES (_user_id, NULL, NULL, NULL, 'DEPOSIT', 0, _description, NOW());

    -- Insert balance history
    INSERT INTO balance_history (user_id, change_amount, new_balance, reason, created_at)
    VALUES (_user_id, _amount, (SELECT total_balance FROM balance WHERE user_id = _user_id), 'DEPOSIT', NOW());
END;
$$;

CREATE OR REPLACE PROCEDURE withdraw_funds(
    _user_id INT,
    _amount NUMERIC(19,6),
    _description TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    _current_balance NUMERIC(19,6);
BEGIN
    -- Fetch the current balance
    SELECT total_balance INTO _current_balance FROM balance WHERE user_id = _user_id;

    -- Prevent negative withdrawals
    IF _amount <= 0 THEN
        RAISE EXCEPTION 'Invalid withdrawal amount';
    END IF;

    -- Prevent insert when nulls 
    IF _current_balance IS NULL THEN
        RAISE EXCEPTION 'There is no balance';
    END IF;

    -- Check if the user has enough funds
    IF _current_balance < _amount THEN
        RAISE EXCEPTION 'Insufficient funds for withdrawal';
    END IF;

    -- Deduct balance
    UPDATE balance
    SET total_balance = total_balance - _amount
    WHERE user_id = _user_id;

    -- Insert transaction record for withdrawal
    INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, details, created_at)
    VALUES (_user_id, NULL, NULL, NULL, 'WITHDRAW', 0, _description, NOW());

    -- Insert into balance history
    INSERT INTO balance_history (user_id, change_amount, new_balance, reason, created_at)
    VALUES (_user_id, -_amount, (SELECT total_balance FROM balance WHERE user_id = _user_id), 'WITHDRAW', NOW());

EXCEPTION WHEN OTHERS THEN
    -- Ensure the error is properly raised
    RAISE;
END;
$$;

CREATE OR REPLACE FUNCTION get_balance(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE plpgsql AS $$
DECLARE
    _current_balance NUMERIC(19,6);
BEGIN
    SELECT ROUND(COALESCE(total_balance, 0), 6) 
    INTO _current_balance 
    FROM balance WHERE user_id = _user_id;
    
    RETURN _current_balance;
END;
$$;



CREATE OR REPLACE FUNCTION get_total_fees(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE 'plpgsql' AS $$
DECLARE
    _total_fees NUMERIC(19,6);
BEGIN
    SELECT COALESCE(ROUND(SUM(fee), 6), 0) INTO _total_fees
    FROM fees
    WHERE user_id = _user_id;

    RETURN _total_fees;
END;
$$;


CREATE OR REPLACE FUNCTION get_portfolio(_user_id INT)
RETURNS TABLE(
    ticker TEXT,
    remaining_quantity NUMERIC(19,6),
    buy_price NUMERIC(19,6),
    total_value NUMERIC(19,6)
) LANGUAGE 'plpgsql' AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.ticker,
        ROUND(p.remaining_quantity, 6) AS remaining_quantity,
        ROUND(p.buy_price, 6) AS buy_price,
        ROUND(p.remaining_quantity * p.buy_price, 6) AS total_value
    FROM portfolio_lots p
    WHERE p.user_id = _user_id AND p.remaining_quantity > 0;
END;
$$;

CREATE OR REPLACE FUNCTION get_total_money_invested(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE 'plpgsql' AS $$
DECLARE
    _total_invested NUMERIC(19,6);
BEGIN
    -- Force rounding at every level
    SELECT COALESCE(
        ROUND(SUM(
            ROUND(buy_price * remaining_quantity, 6) + 
            ROUND(fee, 6)
        ), 6), 0)
    INTO _total_invested
    FROM portfolio_lots
    WHERE user_id = _user_id AND remaining_quantity > 0;

    RETURN _total_invested;
END;
$$;


CREATE OR REPLACE FUNCTION get_total_money_earned(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE 'plpgsql' AS $$
DECLARE
    _total_earned NUMERIC(19,6);
BEGIN
    SELECT ROUND(COALESCE(SUM(price * quantity - fee), 0), 6)
    INTO _total_earned
    FROM transactions
    WHERE user_id = _user_id AND transaction_type = 'SELL';

    RETURN _total_earned;
END;
$$;

CREATE OR REPLACE FUNCTION get_current_portfolio_value(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE 'plpgsql' AS $$
DECLARE
    _portfolio_value NUMERIC(19,6);
BEGIN
    -- Sum total value of all stocks in portfolio
    SELECT COALESCE(ROUND(SUM(remaining_quantity * buy_price), 6), 0) 
    INTO _portfolio_value
    FROM portfolio_lots
    WHERE user_id = _user_id AND remaining_quantity > 0;

    RETURN _portfolio_value;
END;
$$;

CREATE OR REPLACE FUNCTION get_net_profit_loss(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE 'plpgsql' AS $$
DECLARE
    _realized_profit NUMERIC(19,6);
    _unrealized_profit NUMERIC(19,6);
    _net_profit NUMERIC(19,6);
BEGIN
    SELECT ROUND(COALESCE(SUM(realized_profit_loss), 0), 6)
    INTO _realized_profit
    FROM transactions 
    WHERE user_id = _user_id 
    AND transaction_type = 'SELL';

    SELECT ROUND(get_current_portfolio_value(_user_id) - get_total_money_invested(_user_id), 6) 
    INTO _unrealized_profit;

    _net_profit := ROUND(_realized_profit + _unrealized_profit, 6);

    RETURN _net_profit;
END;
$$;



CREATE OR REPLACE FUNCTION get_transaction_history(_user_id INT)
RETURNS TABLE(
    transaction_id INT,
    ticker TEXT,
    transaction_type TEXT,
    price NUMERIC(19,6),
    quantity NUMERIC(19,6),
    fee NUMERIC(19,6),
    realized_profit_loss NUMERIC(19,6),
    details TEXT,
    created_at TIMESTAMP
) LANGUAGE 'plpgsql' AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id AS transaction_id,
        t.ticker,
        t.transaction_type,
        t.price,
        t.quantity,
        t.fee,
        t.realized_profit_loss,
        t.details,
        t.created_at
    FROM transactions t
    WHERE t.user_id = _user_id
    ORDER BY t.created_at DESC;
END;
$$ ;

CREATE OR REPLACE FUNCTION get_monthly_performance(
    _user_id INT,
    _month INT,
    _year INT
) RETURNS TABLE(
    total_invested NUMERIC(19,6),
    total_earned NUMERIC(19,6),
    total_fees NUMERIC(19,6),
    net_profit_loss NUMERIC(19,6)
) LANGUAGE 'plpgsql' AS $$
BEGIN
    RETURN QUERY
    SELECT 
        -- Sum 'buys', total invested
        COALESCE(SUM(CASE WHEN t.transaction_type = 'BUY' THEN (t.price * t.quantity + t.fee) ELSE 0 END), 0) AS total_invested,
        -- Sum sellls, total_earned
        COALESCE(SUM(CASE WHEN t.transaction_type = 'SELL' THEN (t.price * t.quantity - t.fee) ELSE 0 END), 0) AS total_earned,
        COALESCE(SUM(t.fee), 0) AS total_fees,
        
        -- Only sum realized profit loss column  of the sells
        COALESCE(SUM(CASE WHEN t.transaction_type IN ('SELL') THEN t.realized_profit_loss ELSE 0 END), 0) AS net_profit_loss
        
    FROM transactions t
    WHERE t.user_id = _user_id
    AND EXTRACT(MONTH FROM t.created_at) = _month
    AND EXTRACT(YEAR FROM t.created_at) = _year;
END;
$$;


CREATE OR REPLACE FUNCTION get_unrealized_money(_user_id INT)
RETURNS NUMERIC(19,6) LANGUAGE 'plpgsql' AS $$
DECLARE
    _current_value NUMERIC(19,6);
    _cost_basis NUMERIC(19,6);
    _unrealized_profit NUMERIC(19,6);
BEGIN
    -- Get current market value of remaining stocks
    SELECT COALESCE(ROUND(SUM(remaining_quantity * buy_price), 6), 0) 
    INTO _current_value
    FROM portfolio_lots
    WHERE user_id = _user_id AND remaining_quantity > 0;

    -- Get total cost of remaining stocks (excluding sold stocks)
    SELECT COALESCE(ROUND(SUM(buy_price * remaining_quantity), 6), 0) 
    INTO _cost_basis
    FROM portfolio_lots
    WHERE user_id = _user_id AND remaining_quantity > 0;

    -- Unrealized profit calculation
    _unrealized_profit := ROUND((_current_value - _cost_basis), 6);

    RETURN _unrealized_profit;
END;
$$;

CREATE OR REPLACE FUNCTION get_ticker_portfolio_summary(_user_id INT, _ticker TEXT)
RETURNS TABLE(
    ticker TEXT,
    remaining_quantity NUMERIC(19,6),
    total_value NUMERIC(19,6),
    min_price NUMERIC(19,6),
    max_price NUMERIC(19,6),
    avg_buy_price NUMERIC(19,6),
    breakeven_price NUMERIC(19,6),
    total_fees NUMERIC(19,6)
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.ticker,
        ROUND(COALESCE(SUM(p.remaining_quantity), 0), 6) AS remaining_quantity,
        ROUND(COALESCE(SUM(p.remaining_quantity * p.buy_price), 0), 6) AS total_value,
        ROUND(COALESCE(MIN(p.buy_price), 0), 6) AS min_price,
        ROUND(COALESCE(MAX(p.buy_price), 0), 6) AS max_price,
        -- Weighted average buy price
        ROUND(COALESCE(SUM(p.buy_price * p.remaining_quantity) / NULLIF(SUM(p.remaining_quantity), 0), 0), 6) AS avg_buy_price,
        -- Breakeven price
        ROUND(COALESCE((SUM(p.buy_price * p.remaining_quantity) + SUM(p.fee)) / NULLIF(SUM(p.remaining_quantity), 0), 0), 6) AS breakeven_price,
        ROUND(COALESCE(SUM(p.fee), 0), 6) AS total_fees
    FROM portfolio_lots p
    WHERE p.user_id = _user_id AND p.ticker = _ticker
    GROUP BY p.ticker;
END;
$$;

CREATE OR REPLACE PROCEDURE reset_user_data(_user_id INT) LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM portfolio_lots WHERE user_id = _user_id;
    DELETE FROM transactions WHERE user_id = _user_id;
    DELETE FROM balance_history WHERE user_id = _user_id;
    DELETE FROM fees WHERE user_id = _user_id;
    UPDATE balance SET total_balance = 0 WHERE user_id = _user_id;
END;
$$;