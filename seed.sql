-- SEED.SQL - Sample Data for QuickSave Bank

INSERT INTO users (username, email, password_hash, full_name, role, phone, address) VALUES
('john_doe', 'john@email.com', 'hash1', 'John Doe', 'customer', '555-0101', '123 Main St'),
('jane_smith', 'jane@email.com', 'hash2', 'Jane Smith', 'verified_customer', '555-0102', '456 Oak Ave'),
('mike_wilson', 'mike@email.com', 'hash3', 'Mike Wilson', 'loan_officer', '555-0103', '789 Pine Rd'),
('admin_user', 'admin@bank.com', 'hash4', 'Admin User', 'admin', '555-0104', '321 Admin Blvd'),
('auditor1', 'audit@bank.com', 'hash5', 'Audit Person', 'auditor', '555-0105', '654 Audit Ln'),
('sarah_connor', 'sarah@email.com', 'hash6', 'Sarah Connor', 'customer', '555-0106', '987 Tech St'),
('tom_hanks', 'tom@email.com', 'hash7', 'Tom Hanks', 'verified_customer', '555-0107', '456 Actor Ln'),
('lisa_wong', 'lisa@email.com', 'hash8', 'Lisa Wong', 'loan_officer', '555-0108', '321 Banker Ave'),
('peter_parker', 'peter@email.com', 'hash9', 'Peter Parker', 'customer', '555-0109', '10 Queens Blvd'),
('bruce_wayne', 'bruce@email.com', 'hash10', 'Bruce Wayne', 'verified_customer', '555-0110', '1007 Gotham St');


INSERT INTO account_types (type_name, description, minimum_balance, interest_rate) VALUES
('Checking', 'Everyday spending account', 0, 0),
('Savings', 'Interest-bearing savings account', 500, 1.5),
('Student', 'Account for students', 0, 0.5),
('Business', 'For business owners', 1000, 0.75),
('Premium', 'High-tier account', 5000, 2.0);


INSERT INTO accounts (account_number, user_id, account_type_id, balance, currency) VALUES
('ACC1001', 1, 1, 1500.00, 'USD'),
('ACC1002', 1, 2, 5000.00, 'USD'),
('ACC1003', 2, 1, 2500.00, 'USD'),
('ACC1004', 2, 2, 10000.00, 'USD'),
('ACC1005', 3, 1, 3000.00, 'USD'),
('ACC1006', 3, 3, 500.00, 'USD'),
('ACC1007', 4, 4, 50000.00, 'USD'),
('ACC1008', 5, 1, 1000.00, 'USD'),
('ACC1009', 6, 3, 800.00, 'USD'),
('ACC1010', 6, 2, 2000.00, 'USD'),
('ACC1011', 7, 5, 15000.00, 'USD'),
('ACC1012', 7, 1, 3500.00, 'USD'),
('ACC1013', 8, 1, 4200.00, 'USD'),
('ACC1014', 9, 3, 1200.00, 'USD'),
('ACC1015', 10, 5, 25000.00, 'USD'),
('ACC1016', 10, 4, 75000.00, 'USD');


INSERT INTO transactions (from_account_id, to_account_id, amount, transaction_type, status, description, created_at) VALUES
(NULL, 1, 1000.00, 'deposit', 'completed', 'Initial deposit', NOW() - INTERVAL '30 days'),
(1, 3, 200.00, 'transfer', 'completed', 'Rent payment', NOW() - INTERVAL '25 days'),
(3, NULL, 100.00, 'withdrawal', 'completed', 'ATM withdrawal', NOW() - INTERVAL '20 days'),
(2, 4, 500.00, 'transfer', 'completed', 'Savings transfer', NOW() - INTERVAL '15 days'),
(1, 2, 300.00, 'transfer', 'completed', 'To savings', NOW() - INTERVAL '10 days'),
(NULL, 3, 1500.00, 'deposit', 'completed', 'Salary', NOW() - INTERVAL '8 days'),
(3, 1, 50.00, 'transfer', 'completed', 'Coffee money', NOW() - INTERVAL '5 days'),
(2, NULL, 200.00, 'withdrawal', 'completed', 'ATM', NOW() - INTERVAL '3 days'),
(4, 2, 1000.00, 'transfer', 'completed', 'From savings', NOW() - INTERVAL '2 days'),
(1, 3, 75.00, 'transfer', 'completed', 'Dinner', NOW() - INTERVAL '1 day'),
(NULL, 5, 2000.00, 'deposit', 'completed', 'Initial deposit', NOW() - INTERVAL '20 days'),
(5, 6, 100.00, 'transfer', 'completed', 'To student account', NOW() - INTERVAL '15 days'),
(7, NULL, 5000.00, 'withdrawal', 'completed', 'Business expense', NOW() - INTERVAL '10 days'),
(8, 7, 300.00, 'transfer', 'completed', 'Payment', NOW() - INTERVAL '5 days'),
(6, 8, 50.00, 'transfer', 'completed', 'Gift', NOW() - INTERVAL '2 days'),
(10, 11, 2000.00, 'transfer', 'completed', 'Investment', NOW() - INTERVAL '12 days'),
(11, 10, 500.00, 'transfer', 'completed', 'Return', NOW() - INTERVAL '8 days'),
(12, 13, 350.00, 'transfer', 'completed', 'Consulting fee', NOW() - INTERVAL '6 days'),
(NULL, 14, 3000.00, 'deposit', 'completed', 'Bonus', NOW() - INTERVAL '4 days'),
(15, 16, 5000.00, 'transfer', 'completed', 'Business transfer', NOW() - INTERVAL '2 days');


INSERT INTO loans (loan_number, user_id, amount, interest_rate, term_months, monthly_payment, remaining_balance, status, purpose) VALUES
('LOAN1001', 1, 5000.00, 5.5, 12, 429.00, 5000.00, 'approved', 'Car repair'),
('LOAN1002', 2, 10000.00, 4.5, 24, 436.00, 10000.00, 'pending', 'Home improvement'),
('LOAN1003', 3, 2000.00, 6.0, 6, 340.00, 2000.00, 'approved', 'Emergency fund'),
('LOAN1004', 6, 3000.00, 5.0, 12, 257.00, 3000.00, 'active', 'Textbooks'),
('LOAN1005', 7, 15000.00, 4.0, 36, 443.00, 15000.00, 'approved', 'Business expansion'),
('LOAN1006', 9, 1000.00, 6.5, 6, 170.00, 1000.00, 'pending', 'Camera purchase');

INSERT INTO loan_payments (loan_id, payment_number, due_date, paid_date, amount, principal_paid, interest_paid, status) VALUES
(1, 1, '2026-04-01', '2026-04-01', 429.00, 400.00, 29.00, 'paid'),
(1, 2, '2026-05-01', NULL, 429.00, NULL, NULL, 'pending'),
(3, 1, '2026-04-15', '2026-04-15', 340.00, 320.00, 20.00, 'paid'),
(3, 2, '2026-05-15', NULL, 340.00, NULL, NULL, 'pending'),
(4, 1, '2026-04-10', '2026-04-10', 257.00, 240.00, 17.00, 'paid'),
(4, 2, '2026-05-10', NULL, 257.00, NULL, NULL, 'pending'),
(5, 1, '2026-04-20', NULL, 443.00, NULL, NULL, 'pending'),
(6, 1, '2026-05-05', NULL, 170.00, NULL, NULL, 'pending');


INSERT INTO beneficiaries (user_id, beneficiary_account_number, beneficiary_name, nickname) VALUES
(1, 'ACC1003', 'Jane Smith', 'Jane'),
(2, 'ACC1001', 'John Doe', 'John'),
(3, 'ACC1007', 'Admin User', 'Admin'),
(1, 'ACC1005', 'Mike Wilson', 'Mike'),
(2, 'ACC1008', 'Audit Person', 'Auditor'),
(6, 'ACC1011', 'Tom Hanks', 'Tom'),
(7, 'ACC1009', 'Sarah Connor', 'Sarah'),
(9, 'ACC1015', 'Bruce Wayne', 'Bruce'),
(10, 'ACC1002', 'John Doe', 'John D');


INSERT INTO cards (account_id, card_number, card_type, expiry_date, daily_limit) VALUES
(1, '4111111111111111', 'debit', '2027-12-31', 1000),
(3, '4111111111111112', 'debit', '2027-12-31', 1000),
(5, '5111111111111111', 'credit', '2026-06-30', 2000),
(2, '4111111111111113', 'debit', '2028-01-31', 500),
(7, '5111111111111112', 'credit', '2026-12-31', 5000),
(9, '4111111111111114', 'debit', '2027-05-31', 1000),
(11, '5111111111111113', 'credit', '2027-03-31', 3000),
(13, '4111111111111115', 'debit', '2026-11-30', 800),
(15, '5111111111111114', 'credit', '2028-06-30', 10000),
(16, '4111111111111116', 'debit', '2027-09-30', 2000);


INSERT INTO audit_logs (user_id, action, table_name, record_id, ip_address, created_at) VALUES
(1, 'LOGIN', 'users', 1, '192.168.1.100', NOW() - INTERVAL '2 hours'),
(1, 'TRANSFER', 'transactions', 1, '192.168.1.100', NOW() - INTERVAL '90 minutes'),
(2, 'LOGIN', 'users', 2, '192.168.1.101', NOW() - INTERVAL '60 minutes'),
(2, 'VIEW_BALANCE', 'accounts', 3, '192.168.1.101', NOW() - INTERVAL '45 minutes'),
(3, 'LOGIN', 'users', 3, '192.168.1.102', NOW() - INTERVAL '30 minutes'),
(3, 'APPROVE_LOAN', 'loans', 1, '192.168.1.102', NOW() - INTERVAL '20 minutes'),
(4, 'LOGIN', 'users', 4, '192.168.1.103', NOW() - INTERVAL '15 minutes'),
(4, 'VIEW_AUDIT', 'audit_logs', NULL, '192.168.1.103', NOW() - INTERVAL '10 minutes'),
(1, 'LOGOUT', 'users', 1, '192.168.1.100', NOW() - INTERVAL '5 minutes'),
(2, 'ADD_BENEFICIARY', 'beneficiaries', 1, '192.168.1.101', NOW() - INTERVAL '4 minutes'),
(6, 'LOGIN', 'users', 6, '192.168.1.110', NOW() - INTERVAL '3 minutes'),
(6, 'VIEW_LOANS', 'loans', 4, '192.168.1.110', NOW() - INTERVAL '2 minutes'),
(7, 'LOGIN', 'users', 7, '192.168.1.111', NOW() - INTERVAL '1 minute'),
(7, 'TRANSFER', 'transactions', 16, '192.168.1.111', NOW()),
(9, 'LOGIN', 'users', 9, '192.168.1.113', NOW() - INTERVAL '30 seconds'),
(10, 'LOGIN', 'users', 10, '192.168.1.114', NOW() - INTERVAL '20 seconds');


INSERT INTO roundup_settings (user_id, account_id, is_enabled, roundup_target) VALUES
(1, 1, TRUE, 'nearest_dollar'),
(2, 3, TRUE, 'nearest_5'),
(3, 5, FALSE, 'nearest_dollar'),
(4, 7, TRUE, 'nearest_10'),
(6, 9, TRUE, 'nearest_dollar'),
(7, 11, FALSE, 'nearest_dollar'),
(8, 13, TRUE, 'nearest_5'),
(9, 14, TRUE, 'nearest_dollar'),
(10, 15, TRUE, 'nearest_10'),
(10, 16, FALSE, 'nearest_dollar');


-- VERIFICATION QUERY

SELECT 'SEED DATA LOADED SUCCESSFULLY!' as message;
SELECT 
    (SELECT COUNT(*) FROM users) as users,
    (SELECT COUNT(*) FROM account_types) as account_types,
    (SELECT COUNT(*) FROM accounts) as accounts,
    (SELECT COUNT(*) FROM transactions) as transactions,
    (SELECT COUNT(*) FROM loans) as loans,
    (SELECT COUNT(*) FROM loan_payments) as loan_payments,
    (SELECT COUNT(*) FROM beneficiaries) as beneficiaries,
    (SELECT COUNT(*) FROM cards) as cards,
    (SELECT COUNT(*) FROM audit_logs) as audit_logs,
    (SELECT COUNT(*) FROM roundup_settings) as roundup_settings;