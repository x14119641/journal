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
    total_balance NUMERIC(19,6) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_balance_user_id ON balance (user_id);


-- We will store balance history too
CREATE TABLE IF NOT EXISTS balance_history (
	id SERIAL PRIMARY KEY,
	user_id INT REFERENCES users(id),
	balance NUMERIC(19,6) NOT NULL,  
	recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);
CREATE INDEX IF NOT EXISTS idx_balance_history_user_id ON balance_history (user_id);

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
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_ticker_quantity_created UNIQUE (user_id, ticker, created_at)
);
CREATE INDEX IF NOT EXISTS idx_transactions_user_ticker ON transactions (user_id, ticker);

--  Tacks transacitons history
CREATE TABLE IF NOT EXISTS transactions_history (
	id serial PRIMARY KEY,
	user_id INT REFERENCES users(id),
    transaction_id INT REFERENCES transactions(id),
	change_amount NUMERIC(19, 2),
    new_balance NUMERIC(19,6),
	reason TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_transactions_history_user_id ON transactions_history (user_id);

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


-- Create Refresh
CREATE TABLE refresh_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    token TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    expires_at TIMESTAMPTZ,
	ip_address TEXT,
    user_agent TEXT, 
	revoked BOOLEAN DEFAULT FALSE
);

-- HEre will store the "deposits" withraws" or something that extracts or puts money in it the deposi
-- We dont need it anymore because we store everything in ransactions, balance and transactions_history
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



-- Backup table when user deletes transaction
CREATE TABLE IF NOT EXISTS deleted_transactions (
    id SERIAL PRIMARY KEY,
    original_transaction_id INT NOT NULL,
    user_id INT REFERENCES users(id),
    ticker TEXT,
    price NUMERIC(19,6),
    quantity NUMERIC(19,6),
    transaction_type TEXT,
    fee NUMERIC(19,6),
    realized_profit_loss NUMERIC(19,6),
    description TEXT,
    balance_at_deletion NUMERIC(19,6),
    reason TEXT,
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE  user_dividends (
	id SERIAL PRIMARY KEY,
	user_id INT REFERENCES users(id),
	ticker TEXT NOT NULL REFERENCES tickers(ticker),
	ex_date DATE,
	payment_date DATE NOT NULL, -- If no payment_date no enter the dividend
	declared_amount NUMERIC(12,6),
	estimated_payout NUMERIC(19,6), -- remainingQuanitity * declared_amount
	currency TEXT,
	shares_held_at_ex_date NUMERIC(19, 6), -- Number of shares owned at ex-date
	is_executed BOOLEAN DEFAULT FALSE, -- Has the dividend been added to balance?
	executed_at TIMESTAMP, -- When the balance was updated
    inserted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	 CONSTRAINT unique_record UNIQUE (user_id, ticker, ex_date, payment_date)
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
        RETURN 'Error: Deposit amount must be positive';
    END IF;

    -- If the user has no balance record, insert a new one
    INSERT INTO balance (user_id, total_balance)
    VALUES (_user_id, _amount)
    ON CONFLICT (user_id) -- If user_id already exists, do nothing
    DO UPDATE SET total_balance = balance.total_balance + _amount;

    -- insert last total_balance we just updated
    INSERT INTO balance_history (user_id, balance)
    SELECT user_id, total_balance FROM balance WHERE user_id=_user_id;

    -- Insert transaction record for deposit
    INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, description, created_at)
    VALUES (_user_id, NULL, NULL, _amount, 'DEPOSIT', 0, _description,_created_at) 
	RETURNING id into _transaction_id;

    -- Insert transactions history
    INSERT INTO transactions_history (user_id, transaction_id, change_amount, new_balance, reason, created_at)
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
        RETURN 'Error: Invalid withdrawal amount';
    END IF;

    -- Prevent insert when nulls 
    IF _current_balance IS NULL THEN
        RETURN 'Error: There is no balance';
    END IF;

    -- Check if the user has enough funds
    IF _current_balance < _amount THEN
        RETURN 'Error: Insufficient funds for withdrawal';
    END IF;

    -- Deduct balance
    UPDATE balance
    SET total_balance = total_balance - _amount
    WHERE user_id = _user_id;

    -- insert last total_balance we just updated
    INSERT INTO balance_history (user_id, balance)
    SELECT user_id, total_balance FROM balance WHERE user_id=_user_id;

    -- Insert transaction record for withdrawal
    INSERT INTO transactions (user_id, ticker, price, quantity, transaction_type, fee, description, created_at)
    VALUES (_user_id, NULL, NULL, _amount, 'WITHDRAW', 0, _description, _created_at)
    RETURNING id into _transaction_id;

    -- Insert into transactions history
    INSERT INTO transactions_history (user_id, transaction_id,change_amount, new_balance, reason, created_at)
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
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_total_cost NUMERIC(19,6);
	_current_balance NUMERIC(19,6);
	_new_balance NUMERIC(19,6);
    _transaction_id INT;
BEGIN 
    --Check if ticker exists in the database
    IF NOT EXISTS (SELECT 1 FROM tickers WHERE ticker=_ticker) THEN
		RETURN 'Error: Ticker not in db';
	END IF;

	-- Calculate total cost of the purchase
	_total_cost := (_buy_price * _quantity) + _fee;

	-- Get current balance
	SELECT total_balance INTO _current_balance 
	FROM balance WHERE user_id = _user_id;

	-- Ensure sufficient funds
	IF _current_balance < _total_cost THEN
		RETURN 'Error: Insufficient funds';
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

    -- insert last total_balance we just updated
    INSERT INTO balance_history (user_id, balance)
    VALUES(_user_id, _new_balance);

	-- Insert transaction into balance history
	INSERT INTO transactions_history (user_id, transaction_id, change_amount, new_balance, reason, created_at)
	VALUES (_user_id, _transaction_id,-_total_cost, _new_balance, 'BUY', _created_at);

	RETURN 'Success: Stock purchased';
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
    _total_remaining_to_sell NUMERIC(19,6);
    _remaining_to_sell NUMERIC(19,6) := _quantity;
BEGIN
    -- Check if ticker exists
    IF NOT EXISTS (SELECT 1 FROM tickers WHERE ticker = _ticker) THEN
        RETURN 'Error: Ticker not in db';
    END IF;

    -- Check if shares exist
    IF NOT EXISTS (SELECT 1 FROM portfolio_lots WHERE user_id = _user_id AND ticker = _ticker AND remaining_quantity > 0) THEN
        RETURN 'Error: No shares available to sell';
    END IF;

    -- Check if have enough shares
    SELECT sum(remaining_quantity) INTO _total_remaining_to_sell
    FROM portfolio_lots WHERE user_id = _user_id AND ticker = _ticker;
    IF _total_remaining_to_sell < _quantity THEN
        RETURN 'Error: Not enough shares to sell';
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
            RETURN 'Error: Not enough shares to sell';
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

    -- insert last total_balance we just updated
    INSERT INTO balance_history (user_id, balance)
    VALUES(_user_id, _new_balance);

    -- Insert into balance history
    INSERT INTO transactions_history (user_id, transaction_id, change_amount, new_balance, reason, created_at)
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
    _transaction_details RECORD;
    _transaction_remaining_quantity NUMERIC(19,6);
	_current_balance NUMERIC(19,6);
    _previous_balance NUMERIC(19,6);
    _id_of_next_transaction INT;
	_last_dividend_quantity NUMERIC(19,6);
	_actual_dividend_quantity NUMERIC(19,6);
BEGIN
	
    -- Get current balance
    SELECT total_balance INTO _current_balance 
    FROM balance
    WHERE user_id = _user_id;

    -- Get transactions details
    SELECT * INTO _transaction_details
    FROM transactions
    WHERE user_id = _user_id AND id = _transaction_id;
    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Error: Buy transaction not found';
    END IF;

    -- Checkif there is another BUY transaction 
    -- (Only allowing to delete de last item, 
    --this itjs just if user get mistake in somethign to allow him 
    -- to be able to delete it)
    SELECT id INTO _id_of_next_transaction
    FROM transactions 
    WHERE user_id =  _user_id
        AND ticker =  _transaction_details.ticker
        AND created_at > _transaction_details.created_at
        AND transaction_type='BUY'
    LIMIT 1;
    IF FOUND THEN
        RETURN 'Error: You already have another BUY after this transaction, try to delete the transaction with id: ' || _id_of_next_transaction;
    END IF;

	-- Check if the for that stock are "dividends" not executed
	IF EXISTS(SELECT 1 FROM user_dividends WHERE user_id=_user_id AND ticker = _transaction_details.ticker AND is_executed = FALSE) THEN
		 
		 -- Get remaining Quantity from portfolio for that transaction
	    SELECT remaining_quantity INTO _transaction_remaining_quantity
	    FROM portfolio_lots
	    WHERE user_id = _user_id 
	    AND ticker = _transaction_details.ticker 
	    AND created_at = _transaction_details.created_at;
	    
	    -- Check if the quantity of stock is the same of the remaingin_qunatity
	    -- That means that part of the lot has been sold
	    IF (_transaction_details.quantity != _transaction_remaining_quantity) THEN
	        RETURN 'Error: Part of this lot buy lot has been sold and is not possible to delete transaction';
	    END IF;

		-- I am going to cehck if the remianing quanity makes sense comparing with the last quantity od the "dividend"
		 SELECT shares_held_at_ex_date INTO _last_dividend_quantity 
		  FROM user_dividends WHERE user_id = _user_id AND ticker = _transaction_details.ticker  AND is_executed  = TRUE ORDER BY inserted DESC LIMIT 1;
		 SELECT shares_held_at_ex_date INTO _actual_dividend_quantity
		  FROM user_dividends WHERE user_id=_user_id AND  ticker = _transaction_details.ticker AND is_executed = FALSE ORDER BY inserted DESC LIMIT 1;
		IF(_last_dividend_quantity+_transaction_details.quantity!=_actual_dividend_quantity) THEN
			RETURN 'Error: This transaction is not possible to delete. Probably you have dividends for stocks in thsi transaciton.';
		END IF;
	
	
	    -- Insert in deleted_transactions as "backup"
	    INSERT INTO deleted_transactions  (original_transaction_id, user_id, ticker, price, quantity, transaction_type, fee,realized_profit_loss, description, balance_at_deletion,reason, created_at)
	    VALUES (_transaction_id, _user_id,
	         _transaction_details.ticker,  _transaction_details.price, 
	         _transaction_details.quantity, _transaction_details.transaction_type, 
	         _transaction_details.fee, _transaction_details.realized_profit_loss, 
	         _transaction_details.description, _current_balance, 
	         _reason, _transaction_details.created_at);
		
	    -- Delete from balance history
	    DELETE FROM transactions_history WHERE transaction_id = _transaction_id AND user_id = _user_id;
	    
	    -- Delete fees
	    DELETE FROM fees WHERE user_id = _user_id AND transaction_id = _transaction_id;
	    
	    -- Delete from portfolio lots
	    DELETE FROM portfolio_lots 
	    WHERE user_id = _user_id 
	        AND transaction_id = _transaction_id;
	    IF NOT FOUND THEN
	        RETURN 'Error: Error deleting portfolio lot, transaction ID: ' || _transaction_id;
	    END IF;
		
	    -- Delete deposit transaction
	    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;
		
	    -- Get the last balance from balance history *AFTER* deleting
	    SELECT COALESCE(new_balance, 0) INTO _previous_balance
	    FROM transactions_history
	    WHERE user_id = _user_id 
	    ORDER BY created_at DESC
	    LIMIT 1; 
	
	    -- Delete last item in balance history
	    WITH last_balance AS (
		    SELECT id FROM balance_history 
		    WHERE user_id = _user_id 
		    ORDER BY recorded_at DESC 
		    LIMIT 1
		)
		DELETE FROM balance_history 
		WHERE id IN (SELECT id FROM last_balance);
	
	    -- Restore balance to previous state
	    UPDATE balance 
	    SET total_balance = _previous_balance 
	    WHERE user_id = _user_id;

		-- Restore user_dividends
		UPDATE user_dividends
		SET shares_held_at_ex_date = _last_dividend_quantity,
			estimated_payout = shares_held_at_ex_date * declared_amount,
			updated = CURRENT_TIMESTAMP
		WHERE user_id = _user_id
		AND ticker = _transaction_details.ticker
		AND is_executed IS FALSE;
	
	
	    IF NOT FOUND THEN
	        RAISE NOTICE 'Error: Could not delete portfolio lot for transaction' ;
   			RETURN 'Erroe: deleting portfolio lot, transaction ID: ' || _transaction_id;
	    END IF;
		RETURN 'Success: Buy transaction deleted and balance updated';
	
	ELSE
		RETURN 'Error: This transactions has received dividends and is not possible to delete.';
	END IF;
   
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
	_restore_amount NUMERIC(19,6);
    _id_of_next_transaction INT;
BEGIN
    -- Get transaction details
    SELECT * INTO _transaction_details FROM transactions 
    WHERE id = _transaction_id AND user_id = _user_id AND transaction_type = 'SELL';

    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Error: Sell transaction ' || _transaction_id || ' not found for user ' || _user_id;
    END IF;

	
    -- Check if this exist another sell after this one
    -- I only want to be able to delete my last sell transaction, like my balance
    -- will be always correct, cause it will get the balance properly for the correct row in balance
    SELECT id INTO _id_of_next_transaction
    FROM transactions 
    WHERE user_id =  _user_id
        AND ticker =  _transaction_details.ticker
        AND created_at > _transaction_details.created_at
        AND transaction_type='SELL'
    LIMIT 1;
    IF FOUND THEN
        RETURN 'Error: You already have another SELL after this transaction, try to delete the transaction with id: ' || _id_of_next_transaction;
    END IF;

	-- Check if there are executed dividends for this ticker
	IF EXISTS(
	    SELECT 1 
	    FROM user_dividends 
	    WHERE user_id = _user_id 
	    AND ticker = _transaction_details.ticker 
	    AND is_executed = TRUE
	) THEN
	    RETURN 'Error: This sell transaction cannot be deleted because dividends have already been executed for this stock.';
	END IF;

	
	-- Set the total quantity that needs to be restored
 	_transaction_remaining_quantity := _transaction_details.quantity;
    -- Restore FIFO inventory (undo the sell)
    FOR _affected_lots IN
        SELECT * FROM portfolio_lots 
        WHERE user_id = _user_id 
        AND ticker = _transaction_details.ticker
        AND remaining_quantity < quantity -- partially/fully sold 
        ORDER BY created_at ASC
    LOOP
        IF _transaction_remaining_quantity <= 0 THEN
            EXIT;
        END IF;

        -- Determine the amount to restore 
        _restore_amount := LEAST(_transaction_remaining_quantity, (_affected_lots.quantity - _affected_lots.remaining_quantity));

        -- update the sold portion
        UPDATE portfolio_lots 
        SET remaining_quantity = remaining_quantity + _restore_amount
        WHERE id = _affected_lots.id;

        -- Reduce the amount that still needs to be restored
        _transaction_remaining_quantity := _transaction_remaining_quantity - _restore_amount;
    END LOOP;

    -- Insert in deleted_transactions as "backup"
    INSERT INTO deleted_transactions  (original_transaction_id, user_id, ticker, price, quantity, transaction_type, fee,realized_profit_loss, description, balance_at_deletion,reason, created_at)
    VALUES (_transaction_id, _user_id,
         _transaction_details.ticker,  _transaction_details.price, 
         _transaction_details.quantity, _transaction_details.transaction_type, 
         _transaction_details.fee, _transaction_details.realized_profit_loss, 
         _transaction_details.description, 
         (SELECT total_balance FROM balance WHERE user_id = _user_id), -- Current Balance
         _reason, _transaction_details.created_at);

    -- Delete from balance history
    DELETE FROM transactions_history WHERE transaction_id = _transaction_id AND user_id = _user_id;

    -- Delete the sell transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

    -- Delete related fees
    DELETE FROM fees WHERE user_id = _user_id  AND transaction_id = _transaction_id;


	-- Get the last balance from balance history *AFTER* deleting
    SELECT COALESCE(new_balance, 0) INTO _previous_balance
    FROM transactions_history
    WHERE user_id = _user_id 
    ORDER BY created_at DESC
    LIMIT 1; 
	
    -- Delete last item in balance history
    WITH last_balance AS (
	    SELECT id FROM balance_history 
	    WHERE user_id = _user_id 
	    ORDER BY recorded_at DESC 
	    LIMIT 1
	)
	DELETE FROM balance_history 
	WHERE id IN (SELECT id FROM last_balance);


    -- Restore balance to previous state
    UPDATE balance 
    SET total_balance = _previous_balance 
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
    _new_balance NUMERIC(19,6);
    _transaction_details RECORD;
    _id_of_next_transaction INT;
BEGIN
    -- Get current balance
    SELECT total_balance INTO _current_balance 
    FROM balance
    WHERE user_id = _user_id;

    -- Get transaction details (amount and timestamp)
    SELECT * INTO _transaction_details
    FROM transactions
    WHERE id = _transaction_id AND user_id = _user_id AND transaction_type = 'DEPOSIT';

    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Error: Deposit transaction not found';
    END IF;
    -- Checkif there is another DEpoist transaction
    SELECT id INTO _id_of_next_transaction
    FROM transactions 
    WHERE user_id =  _user_id
        AND ticker =  _transaction_details.ticker
        AND created_at > _transaction_details.created_at
        AND transaction_type='DEPOSIT'
    LIMIT 1;
    IF FOUND THEN
        RETURN 'Error: You already have another DEPOSIT after this transaction, try to delete the transaction with id: ' || _id_of_next_transaction;
    END IF;
    -- Check if you have buys before that deposit, 
    -- otherwise i am not going to allow you to delete the deposit
    IF EXISTS(
        SELECT 1 FROM transactions 
        WHERE user_id = _user_id 
        AND transaction_type = 'BUY' 
        AND created_at > _transaction_details.created_at
    ) THEN
        RETURN 'Error: Cannot delete this deposit as you have buy orders after it';
    END IF;
   
    -- Check if the amount of the transaction that
    -- i want to delete is possible because i have enoug balance
    IF (_transaction_details.quantity > _current_balance) THEN
        RETURN 'Error: Insufficient balance to delete this deposit';
    END IF;

    -- Insert in deleted_transactions as "backup"
    INSERT INTO deleted_transactions  (original_transaction_id, user_id, ticker, price, quantity, transaction_type, fee,realized_profit_loss, description, balance_at_deletion, reason, created_at)
    VALUES (_transaction_id, _user_id,
         _transaction_details.ticker,  _transaction_details.price, 
         _transaction_details.quantity, _transaction_details.transaction_type, 
         _transaction_details.fee, _transaction_details.realized_profit_loss, 
         _transaction_details.description, _current_balance, 
         _reason, _transaction_details.created_at);

	-- Delete from balance history
    DELETE FROM transactions_history WHERE transaction_id = _transaction_id AND user_id = _user_id;
	
    -- Delete deposit transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

    -- Update balance (subtract amount)
    _new_balance := _current_balance - _transaction_details.quantity;
    
    -- Delete last item in balance history
    WITH last_balance AS (
	    SELECT id FROM balance_history 
	    WHERE user_id = _user_id 
	    ORDER BY recorded_at DESC 
	    LIMIT 1
	)
	DELETE FROM balance_history 
	WHERE id IN (SELECT id FROM last_balance);

    UPDATE balance 
    SET total_balance = _new_balance
    WHERE user_id = _user_id;

	RETURN 'Success: Transaction Deleted properly!';
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
    _new_balance NUMERIC(19,6);
    _transaction_details RECORD;
BEGIN
    -- Get current balance
    SELECT total_balance INTO _current_balance 
    FROM balance
    WHERE user_id = _user_id;
    
    -- Get transaction details
    SELECT * INTO _transaction_details 
    FROM transactions
    WHERE id = _transaction_id AND user_id = _user_id AND transaction_type = 'WITHDRAW';

    -- Ensure the transaction exists
    IF NOT FOUND THEN
        RETURN 'Error: Withdraw transaction not found';
    END IF;

    -- As it is a withdraw we dont care, we can delete the withdarw and 
    -- add the quantity to the balance 

    -- Insert in deleted_transactions as "backup"
    INSERT INTO deleted_transactions  (original_transaction_id, user_id, ticker, price, quantity, transaction_type, fee,realized_profit_loss, description, balance_at_deletion, reason, created_at)
    VALUES (_transaction_id, _user_id,
         _transaction_details.ticker,  _transaction_details.price, 
         _transaction_details.quantity, _transaction_details.transaction_type, 
         _transaction_details.fee, _transaction_details.realized_profit_loss, 
         _transaction_details.description, _current_balance, 
         _reason, _transaction_details.created_at);

	-- Delete from balance history
    DELETE FROM transactions_history WHERE transaction_id = _transaction_id AND user_id = _user_id;
    -- Delete deposit transaction
    DELETE FROM transactions WHERE id = _transaction_id AND user_id = _user_id;

    
     -- Update balance (add amount)
    _new_balance := _current_balance + _transaction_details.quantity;
    
    -- Delete last item in balance history
    WITH last_balance AS (
	    SELECT id FROM balance_history 
	    WHERE user_id = _user_id 
	    ORDER BY recorded_at DESC 
	    LIMIT 1
	)
	DELETE FROM balance_history 
	WHERE id IN (SELECT id FROM last_balance);


    UPDATE balance 
    SET total_balance = _new_balance
    WHERE user_id = _user_id;


    -- insert last new_balacne we just upda
	
	RETURN 'Success: Transaction Deleted properly';

END;
$BODY$;



CREATE OR REPLACE FUNCTION public.get_balance(
	_user_id integer)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    _current_balance NUMERIC(19,6);
BEGIN
    SELECT ROUND(COALESCE(total_balance, 0), 6) 
    INTO _current_balance 
    FROM balance WHERE user_id = _user_id;
    
    RETURN _current_balance;
END;
$BODY$;

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
    RETURNS TABLE(transactionId integer, ticker text, transactionType text, price numeric, quantity numeric, fee numeric, realizedProfitLoss numeric, description text, created_at timestamp without time zone) 
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
        t.description,
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
    DELETE FROM balance_history WHERE user_id = _user_id;
    DELETE FROM user_dividends WHERE user_id = _user_id;
    DELETE FROM fees WHERE user_id = _user_id;
    DELETE FROM transactions_history WHERE user_id = _user_id;
    DELETE FROM portfolio_lots WHERE user_id = _user_id;
    DELETE FROM transactions WHERE user_id = _user_id;
    UPDATE balance SET total_balance = 0 WHERE user_id = _user_id;
END;
$$;