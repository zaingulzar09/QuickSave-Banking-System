
SELECT current_database() AS current_database;

-- SECTION 1: BEFORE INDEXES 

EXPLAIN ANALYZE 
SELECT * FROM transactions 
WHERE from_account_id = 1;

EXPLAIN ANALYZE 
SELECT * FROM transactions 
WHERE created_at > '2026-01-01';

EXPLAIN ANALYZE 
SELECT * FROM accounts 
WHERE user_id = 1;

EXPLAIN ANALYZE 
SELECT a.account_number, t.amount, t.created_at
FROM accounts a
JOIN transactions t ON a.account_id = t.from_account_id
WHERE a.user_id = 1;

EXPLAIN ANALYZE 
SELECT * FROM loans 
WHERE status = 'pending';

-- SECTION 2: CREATE INDEXES

CREATE INDEX IF NOT EXISTS idx_transactions_from_account 
ON transactions(from_account_id);

CREATE INDEX IF NOT EXISTS idx_transactions_to_account 
ON transactions(to_account_id);

CREATE INDEX IF NOT EXISTS idx_transactions_created_at 
ON transactions(created_at);

CREATE INDEX IF NOT EXISTS idx_accounts_user_id 
ON accounts(user_id);

CREATE INDEX IF NOT EXISTS idx_accounts_account_number 
ON accounts(account_number);

CREATE INDEX IF NOT EXISTS idx_transactions_from_created 
ON transactions(from_account_id, created_at);

CREATE INDEX IF NOT EXISTS idx_loans_status 
ON loans(status);

CREATE INDEX IF NOT EXISTS idx_accounts_status 
ON accounts(status);

CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at 
ON audit_logs(created_at);

CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id 
ON audit_logs(user_id);

CREATE INDEX IF NOT EXISTS idx_beneficiaries_user_id 
ON beneficiaries(user_id);

CREATE INDEX IF NOT EXISTS idx_cards_account_id 
ON cards(account_id);

CREATE INDEX IF NOT EXISTS idx_cards_card_number 
ON cards(card_number);

-- SECTION 3: VERIFY INDEXES WERE CREATED

SELECT 
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- SECTION 4: AFTER INDEXES - FAST QUERIES

EXPLAIN ANALYZE 
SELECT * FROM transactions 
WHERE from_account_id = 1;

EXPLAIN ANALYZE 
SELECT * FROM transactions 
WHERE created_at > '2026-01-01';

EXPLAIN ANALYZE 
SELECT * FROM accounts 
WHERE user_id = 1;

EXPLAIN ANALYZE 
SELECT a.account_number, t.amount, t.created_at
FROM accounts a
JOIN transactions t ON a.account_id = t.from_account_id
WHERE a.user_id = 1;

EXPLAIN ANALYZE 
SELECT * FROM loans 
WHERE status = 'pending';

-- SECTION 5: COMPARE RESULTS

SELECT 
    relname as table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size,
    pg_size_pretty(pg_relation_size(relid)) as data_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as index_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- SECTION 6: INDEX USAGE STATISTICS

SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as number_of_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
