-- Enriched: Transactions with account and customer context
CREATE TABLE IF NOT EXISTS dwh.enriched_transactions AS
SELECT 
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.amount,
    t.transaction_type,
    t.description,
    t.merchant,
    a.customer_id,
    a.account_type,
    c.customer_name,
    c.customer_segment,
    -- Calculate running balance impact
    CASE 
        WHEN t.transaction_type = 'credit' THEN t.amount
        WHEN t.transaction_type = 'debit' THEN -t.amount
        ELSE 0
    END AS balance_impact
FROM staging.transactions t
INNER JOIN staging.accounts a ON t.account_id = a.account_id
INNER JOIN staging.customers c ON a.customer_id = c.customer_id
WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '90 days';

-- Index for performance
CREATE INDEX idx_enriched_trans_date ON dwh.enriched_transactions(transaction_date);
CREATE INDEX idx_enriched_trans_customer ON dwh.enriched_transactions(customer_id);

