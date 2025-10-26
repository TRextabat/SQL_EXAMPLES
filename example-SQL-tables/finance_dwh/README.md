# Finance Data Warehouse Example

A small, realistic example of a finance data warehouse demonstrating clear data lineage.

## Schema Structure

### Layers
1. **Staging** (`staging.*`) - Raw data from external sources
2. **Data Warehouse** (`dwh.*`) - Enriched and cleansed data
3. **Analytics** (`analytics.*`) - Aggregated metrics and reports

## Data Lineage Flow

```
┌─────────────────────┐
│ External Sources    │
└──────────┬──────────┘
           │
           v
┌──────────────────────────────────────┐
│ STAGING LAYER                        │
├──────────────────────────────────────┤
│ • transactions (01)                  │
│ • accounts (02)                      │
│ • customers (03)                     │
└──────────┬───────────────────────────┘
           │
           v (JOIN)
┌──────────────────────────────────────┐
│ DATA WAREHOUSE LAYER                 │
├──────────────────────────────────────┤
│ • enriched_transactions (04)         │
│   (transactions + accounts +         │
│    customers)                        │
└──────────┬───────────────────────────┘
           │
           v (AGGREGATE)
┌──────────────────────────────────────┐
│ ANALYTICS LAYER                      │
├──────────────────────────────────────┤
│ • daily_balances (05)                │
│ • account_balances (05)              │
│ • customer_metrics (06)              │
└──────────────────────────────────────┘
```

## Expected Lineage Relationships

### Tables (Nodes)
- `staging.transactions`
- `staging.accounts`
- `staging.customers`
- `dwh.enriched_transactions`
- `analytics.daily_balances`
- `analytics.account_balances`
- `analytics.customer_metrics`

### Dependencies (Edges)
1. `staging.transactions` → `dwh.enriched_transactions`
2. `staging.accounts` → `dwh.enriched_transactions`
3. `staging.customers` → `dwh.enriched_transactions`
4. `dwh.enriched_transactions` → `analytics.daily_balances`
5. `analytics.daily_balances` → `analytics.account_balances`
6. `dwh.enriched_transactions` → `analytics.customer_metrics`
7. `analytics.account_balances` → `analytics.customer_metrics`

**Total: 7 tables, 7 dependencies**

## Business Logic

1. **Staging**: Load raw data from external systems
2. **Enrichment**: Join transactions with account and customer context
3. **Aggregation**: Calculate daily balances and running totals
4. **Analytics**: Generate customer-level financial metrics

## Test with ETL Analysis

```bash
curl -X POST 'http://localhost:8600/v2/demo-agents/etl/analyze' \
  -H 'Content-Type: application/json' \
  -d '{
    "repo_path": "/home/user/D/doc-service/EXAMPLE_SQL/finance_dwh",
    "enable_lineage": true,
    "enable_draft": true
  }'
```

