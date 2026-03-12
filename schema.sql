-- SCHEMA.SQL - QuickSave Bank Database

-- TABLE 1: users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('customer', 'verified_customer', 'loan_officer', 'admin', 'auditor')),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- TABLE 2: account_types
CREATE TABLE account_types (
    account_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    minimum_balance DECIMAL(10,2) DEFAULT 0,
    interest_rate DECIMAL(5,2) DEFAULT 0,
    monthly_fee DECIMAL(10,2) DEFAULT 0
);

-- TABLE 3: accounts
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    account_type_id INT NOT NULL REFERENCES account_types(account_type_id),
    balance DECIMAL(15,2) DEFAULT 0 CHECK (balance >= 0),
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'frozen', 'closed')),
    opened_date DATE DEFAULT CURRENT_DATE,
    closed_date DATE,
    last_transaction_date TIMESTAMP
);

-- TABLE 4: transactions
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_uuid UUID DEFAULT gen_random_uuid(),
    from_account_id INT REFERENCES accounts(account_id),
    to_account_id INT REFERENCES accounts(account_id),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    transaction_type VARCHAR(30) NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer', 'fee', 'interest')),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'reversed')),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    CONSTRAINT valid_accounts CHECK ((from_account_id IS NOT NULL) OR (to_account_id IS NOT NULL))
);

-- TABLE 5: loans
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    loan_number VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL REFERENCES users(user_id),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    interest_rate DECIMAL(5,2) NOT NULL,
    term_months INT NOT NULL,
    monthly_payment DECIMAL(15,2) NOT NULL,
    remaining_balance DECIMAL(15,2) NOT NULL CHECK (remaining_balance >= 0),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'active', 'paid', 'defaulted')),
    application_date DATE DEFAULT CURRENT_DATE,
    approval_date DATE,
    purpose TEXT
);

-- TABLE 6: loan_payments
CREATE TABLE loan_payments (
    payment_id SERIAL PRIMARY KEY,
    loan_id INT NOT NULL REFERENCES loans(loan_id) ON DELETE CASCADE,
    payment_number INT NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE,
    amount DECIMAL(15,2) NOT NULL,
    principal_paid DECIMAL(15,2),
    interest_paid DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'late', 'missed')),
    UNIQUE(loan_id, payment_number)
);

-- TABLE 7: beneficiaries
CREATE TABLE beneficiaries (
    beneficiary_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    beneficiary_account_number VARCHAR(20) NOT NULL,
    beneficiary_name VARCHAR(100) NOT NULL,
    nickname VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, beneficiary_account_number)
);

-- TABLE 8: cards
CREATE TABLE cards (
    card_id SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
    card_number VARCHAR(16) UNIQUE NOT NULL,
    card_type VARCHAR(20) CHECK (card_type IN ('debit', 'credit', 'prepaid')),
    expiry_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'blocked', 'expired')),
    daily_limit DECIMAL(15,2) DEFAULT 1000,
    issued_date DATE DEFAULT CURRENT_DATE
);

-- TABLE 9: audit_logs
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50),
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE 10: roundup_settings
CREATE TABLE roundup_settings (
    setting_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    account_id INT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
    is_enabled BOOLEAN DEFAULT FALSE,
    roundup_target VARCHAR(20) DEFAULT 'nearest_dollar' CHECK (roundup_target IN ('nearest_dollar', 'nearest_5', 'nearest_10')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, account_id)
);

-- INDEXES
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_account_number ON accounts(account_number);
CREATE INDEX idx_transactions_from_account ON transactions(from_account_id);
CREATE INDEX idx_transactions_to_account ON transactions(to_account_id);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
CREATE INDEX idx_loans_user_id ON loans(user_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);