-- Staging: Account master data
CREATE TABLE IF NOT EXISTS staging.accounts (
    account_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    account_type VARCHAR(20) NOT NULL, -- 'checking', 'savings', 'credit'
    account_status VARCHAR(20) DEFAULT 'active',
    open_date DATE NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Load account master data
INSERT INTO staging.accounts 
SELECT * FROM external_data.account_master
WHERE account_status = 'active';

