-- Analytics: Customer-level financial metrics and behavior
CREATE TABLE IF NOT EXISTS analytics.customer_metrics AS
SELECT 
    et.customer_id,
    et.customer_name,
    et.customer_segment,
    COUNT(DISTINCT et.account_id) AS total_accounts,
    COUNT(et.transaction_id) AS total_transactions,
    SUM(CASE WHEN et.transaction_type = 'credit' THEN et.amount ELSE 0 END) AS total_inflows,
    SUM(CASE WHEN et.transaction_type = 'debit' THEN et.amount ELSE 0 END) AS total_outflows,
    SUM(et.balance_impact) AS net_position,
    AVG(et.amount) AS avg_transaction_amount,
    MAX(et.transaction_date) AS last_transaction_date,
    -- Join with account balances to get current total balance
    SUM(ab.running_balance) AS total_balance_all_accounts
FROM dwh.enriched_transactions et
LEFT JOIN analytics.account_balances ab 
    ON et.account_id = ab.account_id 
    AND ab.balance_date = (
        SELECT MAX(balance_date) 
        FROM analytics.account_balances 
        WHERE account_id = et.account_id
    )
GROUP BY 
    et.customer_id,
    et.customer_name,
    et.customer_segment;

-- Index for reporting queries
CREATE INDEX idx_customer_metrics_segment ON analytics.customer_metrics(customer_segment);

