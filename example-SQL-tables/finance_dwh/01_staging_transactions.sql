-- Staging: Raw transaction data from external sources
CREATE TABLE IF NOT EXISTS staging.transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    account_id VARCHAR(50) NOT NULL,
    transaction_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL, -- 'debit' or 'credit'
    description VARCHAR(255),
    merchant VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Load raw transaction data
INSERT INTO staging.transactions 
SELECT * FROM external_data.raw_transactions
WHERE transaction_date >= CURRENT_DATE - INTERVAL '90 days';

