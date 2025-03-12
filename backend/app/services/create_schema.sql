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
    transaction_id INT REFERENCES transactions(id),
	change_amount NUMERIC(19, 2),
    new_balance NUMERIC(19,6),
	reason TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_balance_history_user_id ON balance_history (user_id);

-- Create Portfolio and its relations
CREATE TABLE IF NOT EXISTS portfolio_lots (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    transaction_id INT REFERENCES transactions(id),
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


-- In order to the user to modify or delete a transaction (perhaps he introduced a wrong number)
-- I need to create a table to store those changes
-- AN instead to "modify" the transactoon i will need to "reverse" that transaction
-- If user deposit 100e, but he wanted to insert 1000 and he wants to modify the deposit
-- I will insert a -100e deposit as correction and then add the deposit of 1000
-- If user wants to modify deposit but already has bought stocks need to check the balance
-- IF the balance does not allow to "maintain" those stocks
-- Then send a message ot user to modify or delete purchases before update the depoisit
-- Probably i will ned more "checks"
CREATE TABLE IF NOT EXISTS balance_corrections (
    id SERIAL PRIMARY KEY,
    original_transaction_id INT REFERENCES transactions(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id),
    original_amount NUMERIC(19, 6),
    corrected_amount NUMERIC(19,6),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)


CREATE TABLE IF NOT EXISTS transactions_corrections (
    id SERIAL PRIMARY KEY,
    original_transaction_id INT REFERENCES transactions(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id),
    description TEXT,
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




CREATE OR REPLACE FUNCTION public.deposit_funds(
	IN _user_id integer,
	IN _amount numeric,
	IN _description text,
	IN _created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
RETURNS TEXT LANGUAGE 'plpgsql'
AS $BODY$
DECLARE _transaction_id integer;
BEGIN
    -- Ensure the amount is positive
    IF _amount <= 0 THEN
        RETURN 'Deposit amount must be positive';
    END IF;

    -- If the user has no balance record, insert a new one
    INSERT INTO balance (user_id, total_balance)
    VALUES (_user_id, _amount)
    ON CONFLICT (user_id) -- If user_id already exists, do nothing
    DO UPDATE SET total_balance = balance.total_balance + _amount;

    -- Insert transaction record for deposit
    INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, details, created_at)
    VALUES (_user_id, NULL, NULL, _amount, 'DEPOSIT', 0, _description,_created_at) 
	RETURNING id into _transaction_id;

    -- Insert balance history
    INSERT INTO balance_history (user_id, transaction_id, change_amount, new_balance, reason, created_at)
    VALUES (_user_id, _transaction_id,_amount, (SELECT total_balance FROM balance WHERE user_id = _user_id), 'DEPOSIT',_created_at);
    
    RETURN 'Success: Deposit Completed.';
END;
$BODY$;

CREATE OR REPLACE Function public.withdraw_funds(
	IN _user_id integer,
	IN _amount numeric,
	IN _description text,
	IN _created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
RETURNS TEXT LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    _current_balance NUMERIC(19,6);
    _transaction_id integer;
BEGIN
    -- Fetch the current balance
    SELECT total_balance INTO _current_balance FROM balance WHERE user_id = _user_id;

    -- Prevent negative withdrawals
    IF _amount <= 0 THEN
        RETURN 'Invalid withdrawal amount';
    END IF;

    -- Prevent insert when nulls 
    IF _current_balance IS NULL THEN
        RETURN 'There is no balance';
    END IF;

    -- Check if the user has enough funds
    IF _current_balance < _amount THEN
        RETURN 'Insufficient funds for withdrawal';
    END IF;

    -- Deduct balance
    UPDATE balance
    SET total_balance = total_balance - _amount
    WHERE user_id = _user_id;

    -- Insert transaction record for withdrawal
    INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, details, created_at)
    VALUES (_user_id, NULL, NULL, _amount, 'WITHDRAW', 0, _description, _created_at)
    RETURNING id into _transaction_id;

    -- Insert into balance history
    INSERT INTO balance_history (user_id, transaction_id,change_amount, new_balance, reason, created_at)
    VALUES (_user_id, _transaction_id,-_amount, (SELECT total_balance FROM balance WHERE user_id = _user_id), 'WITHDRAW', _created_at);

    RETURN 'Success: Withdraw Completed.';
EXCEPTION WHEN OTHERS THEN
    -- Ensure the error is properly raised
    RAISE;
END;
$BODY$;


CREATE OR REPLACE FUNCTION public.buy_stock(
	_user_id integer,
	_ticker text,
	_buy_price numeric,
	_quantity numeric,
	_fee numeric,
	_created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE AS $BODY$
DECLARE
	_total_cost NUMERIC(19,6);
	_current_balance NUMERIC(19,6);
	_new_balance NUMERIC(19,6);
    _transaction_id INT;
BEGIN 
    --Check if ticker exists in the database
    IF NOT EXISTS (SELECT 1 FROM tickers WHERE ticker=_ticker) THEN
		RETURN 'Ticker not in db';
	END IF;

	-- Calculate total cost of the purchase
	_total_cost := (_buy_price * _quantity) + _fee;

	-- Get current balance
	SELECT total_balance INTO _current_balance 
	FROM balance WHERE user_id = _user_id;

	-- Ensure sufficient funds
	IF _current_balance < _total_cost THEN
		RETURN 'Insufficient funds';
	END IF;

	-- Insert transaction record for the buy action
	INSERT INTO transactions(user_id, ticker, price, quantity, transaction_type, fee, created_at)
	VALUES(_user_id, _ticker, _buy_price, _quantity, 'BUY', _fee, _created_at)
    RETURNING id INTO _transaction_id;

    -- INsert into fees
    INSERT INTO fees(user_id, ticker, transaction_id, type, fee, created_at)
    VALUES (_user_id, _ticker, _transaction_id, 'SELL', _fee, _created_at);

	-- Insert into portfolio (FIFO tracking)
	INSERT INTO portfolio_lots(user_id, ticker, transaction_id, buy_price, quantity, remaining_quantity, fee, created_at)
	VALUES(_user_id, _ticker, _transaction_id, _buy_price, _quantity, _quantity, _fee, _created_at);

	-- Subtract the cost from the balance
	_new_balance := _current_balance - _total_cost;
	UPDATE balance SET total_balance = _new_balance WHERE user_id = _user_id;

	-- Insert transaction into balance history
	INSERT INTO balance_history (user_id, transaction_id, change_amount, new_balance, reason, created_at)
	VALUES (_user_id, _transaction_id,-_total_cost, _new_balance, 'BUY', _created_at);

	RETURN 'Stock purchased';
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.sell_stock(
    _user_id integer,
    _ticker text,
    _price numeric,
    _quantity numeric,
    _fee numeric,
    _created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP)
RETURNS text
LANGUAGE 'plpgsql'
AS $BODY$
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
        RETURN 'Ticker not in db';
    END IF;

    -- Check if shares exist
    IF NOT EXISTS (SELECT 1 FROM portfolio_lots WHERE user_id = _user_id AND ticker = _ticker AND remaining_quantity > 0) THEN
        RETURN 'No shares available to sell';
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
            RETURN 'Not enough shares to sell';
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

            -- Update to 0
            UPDATE portfolio_lots 
            SET remaining_quantity = 0
            WHERE id = _lot.id;
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

    -- Calculate final profit/loss (deducting fee)
    _profit_loss := (_total_sell_value - _total_cost_basis - _total_allocated_fee);

    -- Insert transaction record
    INSERT INTO transactions(user_id, ticker, price, quantity, transaction_type, fee, realized_profit_loss, created_at)
    VALUES (_user_id, _ticker, _price, _quantity, 'SELL', _fee, _profit_loss, _created_at)
    RETURNING id INTO _transaction_id;

    -- Insert into fees table (for later restoration)
    INSERT INTO fees(user_id, ticker, transaction_id, type, fee, created_at)
    VALUES (_user_id, _ticker, _transaction_id, 'SELL', _fee, _created_at);
    
    -- Update balance **AFTER** subtracting fees
    SELECT total_balance INTO _current_balance FROM balance WHERE user_id = _user_id;
    _new_balance := _current_balance + _total_sell_value - _fee;

    UPDATE balance 
    SET total_balance = _new_balance
    WHERE user_id = _user_id;

    -- Insert into balance history
    INSERT INTO balance_history (user_id, transaction_id, change_amount, new_balance, reason, created_at)
    VALUES (_user_id, _transaction_id, _total_sell_value - _fee, _new_balance, 'SELL', _created_at);

    -- Return success message
    RETURN 'Success: Sold ' || _quantity || ' shares of ' || _ticker || ' Profit/Loss: ' || _profit_loss;
END;
$BODY$;



CREATE OR REPLACE FUNCTION delete_buy_transaction(
    _user_id INT,
    _transaction_id INT,
    _reason TEXT
) RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE
    _current_balance NUMERIC(19,6);
    _transaction_ticker TEXT;
    _transaction_created_at timestamp;
    _transaction_quantity NUMERIC(19,6);
    _transaction_cost NUMERIC(19,6);
    _transaction_remaining_quantity NUMERIC(19,6);
	_previous_balance NUMERIC(19,6);

BEGIN
    -- Get transactions details
    SELECT ticker, created_at INTO _transaction_ticker, _transaction_created_at
    FROM transactions
    WHERE user_id = _user_id AND id = _transaction_id;
    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Buy transaction not found';
    END IF;
	
    -- Get Portfolio details
    SELECT quantity, remaining_quantity, (quantity*buy_price-fee) INTO _transaction_quantity, _transaction_remaining_quantity, _transaction_cost
    FROM portfolio_lots
    WHERE user_id = _user_id AND ticker = _transaction_ticker AND created_at = _transaction_created_at;
    
    -- Check if the quantity of stock is the same of the remaingin_qunatity
    -- That means that part of the lot has not been sold
    IF (_transaction_quantity != _transaction_remaining_quantity) THEN
        RETURN 'Part of this lot buy lot has been sold and is not possible to delete transaction';
    END IF;

    -- Insert correction record
    INSERT INTO transactions_corrections (original_transaction_id, user_id, description, reason)
    VALUES (_transaction_id, _user_id, 'Delete Buy Transaction',_reason);
	
    -- Delete from balance history
    DELETE FROM balance_history WHERE transaction_id = _transaction_id AND user_id = _user_id;
    
    -- Delete fees
    DELETE FROM fees WHERE user_id = _user_id AND ticker = _transaction_ticker AND transaction_id = _transaction_id;
    
	-- Update balance (restore adding the totalcost of that transaction)
    -- Delete from portfolio lots
    DELETE FROM portfolio_lots WHERE user_id = _user_id AND ticker = _transaction_ticker AND transaction_id = _transaction_id;
    IF NOT FOUND THEN
        RETURN 'Error deleting portfolio lot, transaction ID: ' || _transaction_id;
    END IF;
	
    -- Delete deposit transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

	    -- Get the last balance from balance history *AFTER* deleting
    SELECT new_balance INTO _previous_balance
    FROM balance_history
    WHERE user_id = _user_id 
    ORDER BY created_at DESC
    LIMIT 1;
	
    UPDATE balance 
    SET total_balance = _previous_balance
    WHERE user_id = _user_id;
    IF NOT FOUND THEN
        RETURN 'Error updating balance';
    END IF;
	RETURN 'Success! Buy transaction deleted and balance updated';
END;
$$;

CREATE OR REPLACE FUNCTION delete_sell_transaction(
    _user_id INT,
    _transaction_id INT,
    _reason TEXT
) RETURNS TEXT LANGUAGE plpgsql AS $$

DECLARE
    _transaction_details RECORD;
    _previous_balance NUMERIC(19,6);
    _transaction_remaining_quantity NUMERIC(19,6);
	_transaction_quantity NUMERIC(19,6);
    _affected_lots RECORD;
    _fee NUMERIC(19,6);
	_restore_amount NUMERIC(19,6);
BEGIN
    -- Get transaction details
    SELECT * INTO _transaction_details FROM transactions 
    WHERE id = _transaction_id AND user_id = _user_id AND transaction_type = 'SELL';

    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Sell transaction ' || _transaction_id || ' not found for user ' || _user_id;
    END IF;

    -- Get the transaction fee before deleting
    SELECT fee INTO _fee
    FROM fees
    WHERE user_id = _user_id AND transaction_id = _transaction_id;

    -- Get Portfolio details
    SELECT quantity, remaining_quantity  INTO _transaction_quantity, _transaction_remaining_quantity
    FROM portfolio_lots
    WHERE user_id = _user_id AND ticker = _transaction_details.ticker AND transaction_id=_transaction_id;
	-- Check if the quantity of stock is the same of the remaingin_qunatity
    -- That means that part of the lot has not been sold
    IF (_transaction_quantity != _transaction_remaining_quantity) THEN
        RETURN 'Part of this lot buy lot has been sold and is not possible to delete transaction';
    END IF;
	
 
    -- Restore FIFO inventory (undo the sell)
FOR _affected_lots IN
    SELECT * FROM portfolio_lots 
    WHERE user_id = _user_id AND ticker = _transaction_details.ticker 
    ORDER BY created_at ASC
LOOP
    IF _transaction_remaining_quantity <= 0 THEN
        EXIT;
    END IF;

    -- Determine the amount to restore (but never exceed original quantity)
    
    _restore_amount := LEAST(_transaction_remaining_quantity, (_affected_lots.quantity - _affected_lots.remaining_quantity));

    -- If the lot was fully sold (`remaining_quantity = 0`), restore it completely
    IF _affected_lots.remaining_quantity = 0 THEN
        UPDATE portfolio_lots 
        SET remaining_quantity = _restore_amount,
            fee = _affected_lots.fee
        WHERE id = _affected_lots.id;
    ELSE
        -- Otherwise, only update the sold portion
        UPDATE portfolio_lots 
        SET remaining_quantity = remaining_quantity + _restore_amount
        WHERE id = _affected_lots.id;
    END IF;

    -- Reduce the amount that still needs to be restored
    _transaction_remaining_quantity := _transaction_remaining_quantity - _restore_amount;
END LOOP;

    -- Insert correction record
    INSERT INTO transactions_corrections (original_transaction_id, user_id, description, reason, created_at)
    VALUES (_transaction_id, _user_id, 'Deleted Sell Transaction', _reason, NOW());

    -- Delete from balance history
    DELETE FROM balance_history WHERE transaction_id = _transaction_id AND user_id = _user_id;

    -- Delete the sell transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

    -- Delete related fees
    DELETE FROM fees WHERE user_id = _user_id AND ticker = _transaction_details.ticker AND transaction_id = _transaction_id;

    -- Get the last balance from balance history *AFTER* deleting
    SELECT new_balance INTO _previous_balance
    FROM balance_history
    WHERE user_id = _user_id 
    ORDER BY created_at DESC
    LIMIT 1;

    -- Restore balance to previous state
    UPDATE balance 
    SET total_balance = _previous_balance   -- Restore fee amount
    WHERE user_id = _user_id;

    -- Return success message
    RETURN 'Success: Sell transaction ' || _transaction_id || ' deleted for user ' || _user_id || ', Ticker: ' || _transaction_details.ticker;

END;
$$;


CREATE OR REPLACE FUNCTION public.delete_deposit_transaction(
	_user_id integer,
	_transaction_id integer,
	_reason text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    _current_balance NUMERIC(19,6);
    _transaction_quantity NUMERIC(19,6);
    _transaction_created_at TIMESTAMP;
BEGIN
    -- Get current balance
    SELECT total_balance INTO _current_balance 
    FROM balance
    WHERE user_id = _user_id;

    -- Get transaction details (amount and timestamp)
    SELECT quantity, created_at INTO _transaction_quantity, _transaction_created_at
    FROM transactions
    WHERE id = _transaction_id AND user_id = _user_id AND transaction_type = 'DEPOSIT';

    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Deposit transaction not found';
    END IF;

    -- Check if you have buys before that deposit, 
    -- otherwise i am not going to allow you to delete the deposit
    IF EXISTS(
        SELECT 1 FROM transactions 
        WHERE user_id = _user_id 
        AND transaction_type = 'BUY' 
        AND created_at > _transaction_created_at
    ) THEN
        RETURN 'Cannot delete this deposit as you have buy orders after it';
    END IF;
   
    -- Check if the amount of the transaction that
    -- i want to delete is possible because i have enoug balance
    IF (_transaction_quantity > _current_balance) THEN
        RETURN 'Insufficient balance to delete this deposit';
    END IF;

    -- Insert correction record
    INSERT INTO transactions_corrections (original_transaction_id, user_id, description, reason)
    VALUES (_transaction_id, _user_id, 'Delete Deposit Transaction',_reason);

	-- Delete from balance history
    DELETE FROM balance_history WHERE transaction_id = _transaction_id AND user_id = _user_id;
	
    -- Delete deposit transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

    -- Update balance (subtract amount)
    UPDATE balance 
    SET total_balance = total_balance - _transaction_quantity
    WHERE user_id = _user_id;
	RETURN 'Success! Transaction Deleted properly!';
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.delete_withdraw_transaction(
	_user_id integer,
	_transaction_id integer,
	_reason text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    _current_balance NUMERIC(19,6);
    _transaction_quantity NUMERIC(19,6);
BEGIN
    -- Get current balance
    SELECT total_balance INTO _current_balance 
    FROM balance
    WHERE user_id = _user_id;
    
    -- Get original quanitty
    SELECT quantity INTO _transaction_quantity 
    FROM transactions
    WHERE id = _transaction_id AND user_id = _user_id AND transaction_type = 'WITHDRAW';

    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Withdraw transaction not found';
    END IF;

    -- As it is a withdraw we dont care, we can delete the withdarw and 
    -- add the quantity to the balance 

    -- Insert correction record
    INSERT INTO transactions_corrections (original_transaction_id, user_id, description, reason)
    VALUES (_transaction_id, _user_id, 'Delete Withdraw Transaction',_reason);

	-- Delete from balance history
    DELETE FROM balance_history WHERE transaction_id = _transaction_id AND user_id = _user_id;
    -- Delete deposit transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

    

    -- Update balance (subtract amount)
    UPDATE balance 
    SET total_balance = total_balance + _transaction_quantity
    WHERE user_id = _user_id;
	
	RETURN 'Success! Transaction Deleted properly';

END;
$BODY$;




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


CREATE OR REPLACE FUNCTION public.get_portfolio(
	_user_id integer)
    RETURNS TABLE(ticker text, remainingQuantity numeric, buyPrice numeric, totalValue numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        p.ticker,
        ROUND(p.remaining_quantity, 6) AS "remainingQuantity",
        ROUND(p.buy_price, 6) AS "buyPrice",
        ROUND(p.remaining_quantity * p.buy_price, 6) AS "totalValue"
    FROM portfolio_lots p
    WHERE p.user_id = _user_id AND p.remaining_quantity > 0;
END;
$BODY$;

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



CREATE OR REPLACE FUNCTION public.get_transaction_history(
	_user_id integer)
    RETURNS TABLE(transactionId integer, ticker text, transactionType text, price numeric, quantity numeric, fee numeric, realizedProfitLoss numeric, details text, created_at timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        t.id as "transactionId",
        t.ticker,
        t.transaction_type as "transactionType",
        t.price,
        t.quantity,
        t.fee,
        t.realized_profit_loss as "realizedProfitLoss",
        t.details,
        t.created_at
    FROM transactions t
    WHERE t.user_id = _user_id
    ORDER BY t.created_at DESC;
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.get_monthly_performance(
	_user_id integer,
	_month integer,
	_year integer)
    RETURNS TABLE(totalInvested numeric, totalEarned numeric, totalFees numeric, netProfitLoss numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        -- Sum 'buys', total invested
        COALESCE(SUM(CASE WHEN t.transaction_type = 'BUY' THEN (t.price * t.quantity + t.fee) ELSE 0 END), 0) AS "totalInvested",
        -- Sum sellls, total_earned
        COALESCE(SUM(CASE WHEN t.transaction_type = 'SELL' THEN (t.price * t.quantity - t.fee) ELSE 0 END), 0) AS "totalEarned",
        COALESCE(SUM(t.fee), 0) AS "totalFees",
        
        -- Only sum realized profit loss column  of the sells
        COALESCE(SUM(CASE WHEN t.transaction_type IN ('SELL') THEN t.realized_profit_loss ELSE 0 END), 0) AS "netProfitLoss"
        
    FROM transactions t
    WHERE t.user_id = _user_id
    AND EXTRACT(MONTH FROM t.created_at) = _month
    AND EXTRACT(YEAR FROM t.created_at) = _year;
END;
$BODY$;


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

CREATE OR REPLACE FUNCTION public.get_ticker_portfolio_summary(
	_user_id integer,
	_ticker text)
    RETURNS TABLE(ticker text, remainingQuantity numeric, totalValue numeric, minPrice numeric, maxPrice numeric, avgBuyPrice numeric, breakeven numeric, totalFees numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        p.ticker,
        ROUND(COALESCE(SUM(p.remaining_quantity), 0), 6) AS "remainingQuantity",
        ROUND(COALESCE(SUM(p.remaining_quantity * p.buy_price), 0), 6) AS "totalValue",
        ROUND(COALESCE(MIN(p.buy_price), 0), 6) AS "minPrice",
        ROUND(COALESCE(MAX(p.buy_price), 0), 6) AS "maxPrice",
        -- Weighted average buy price
        ROUND(COALESCE(SUM(p.buy_price * p.remaining_quantity) / NULLIF(SUM(p.remaining_quantity), 0), 0), 6) AS "avgBuyPrice",
        -- Breakeven price
        ROUND(COALESCE((SUM(p.buy_price * p.remaining_quantity) + SUM(p.fee)) / NULLIF(SUM(p.remaining_quantity), 0), 0), 6) AS "breakeven",
        ROUND(COALESCE(SUM(p.fee), 0), 6) AS "totalFees"
    FROM portfolio_lots p
    WHERE p.user_id = _user_id AND p.ticker = _ticker
    GROUP BY p.ticker;
END;
$BODY$;

CREATE OR REPLACE PROCEDURE reset_user_data(_user_id INT) LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM portfolio_lots WHERE user_id = _user_id;
    DELETE FROM transactions WHERE user_id = _user_id;
    DELETE FROM balance_history WHERE user_id = _user_id;
    DELETE FROM fees WHERE user_id = _user_id;
    UPDATE balance SET total_balance = 0 WHERE user_id = _user_id;
END;
$$;