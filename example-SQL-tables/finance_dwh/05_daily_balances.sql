-- Analytics: Daily account balances aggregated from transactions
CREATE TABLE IF NOT EXISTS analytics.daily_balances AS
SELECT 
    account_id,
    customer_id,
    transaction_date AS balance_date,
    account_type,
    SUM(balance_impact) AS daily_net_change,
    COUNT(transaction_id) AS transaction_count,
    SUM(CASE WHEN transaction_type = 'credit' THEN amount ELSE 0 END) AS total_credits,
    SUM(CASE WHEN transaction_type = 'debit' THEN amount ELSE 0 END) AS total_debits
FROM dwh.enriched_transactions
GROUP BY 
    account_id, 
    customer_id, 
    transaction_date,
    account_type
ORDER BY account_id, transaction_date;

-- Calculate running balance
CREATE TABLE IF NOT EXISTS analytics.account_balances AS
SELECT 
    account_id,
    customer_id,
    balance_date,
    daily_net_change,
    SUM(daily_net_change) OVER (
        PARTITION BY account_id 
        ORDER BY balance_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_balance
FROM analytics.daily_balances;

