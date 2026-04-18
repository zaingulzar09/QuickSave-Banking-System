from backend.jwt_handler import create_access_token
from backend.jwt_handler import get_current_user_role
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os
from backend.auth import verify_password
from fastapi import FastAPI, HTTPException, Body

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DATABASE_URL)

app = FastAPI()
def require_role(user_role: str, allowed_roles: list[str]):
    if user_role not in allowed_roles:
        raise HTTPException(status_code=403, detail="Access denied")

@app.get("/api/v1")
def home():
    return {"message": "QuickSave backend is running"}

@app.get("/api/v1/users")
def get_users(token: str):
    role = get_current_user_role(token)
    require_role(role, ["admin", "auditor"])

    try:
        with engine.connect() as connection:
            result = connection.execute(
                text("""
                    SELECT user_id, username, email, full_name, role
                    FROM users
                    LIMIT 5
                """)
            ).mappings().all()

            users = []
            for row in result:
                users.append({
                    "user_id": row["user_id"],
                    "username": row["username"],
                    "email": row["email"],
                    "full_name": row["full_name"],
                    "role": row["role"]
                })

            return users

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))    
    
@app.get("/api/v1/accounts")
def get_accounts(token: str):
    role = get_current_user_role(token)
    require_role(role, ["admin", "customer", "auditor"])

    with engine.connect() as connection:
        result = connection.execute(
            text("""
                SELECT account_id, user_id, account_number, balance, currency, status
                FROM accounts
                LIMIT 5
            """)
        ).mappings().all()

        accounts = []
        for row in result:
            accounts.append({
                "account_id": row["account_id"],
                "user_id": row["user_id"],
                "account_number": row["account_number"],
                "balance": float(row["balance"]),
                "currency": row["currency"],
                "status": row["status"]
            })

        return accounts
@app.get("/api/v1/transactions")
def get_transactions(token: str):
    role = get_current_user_role(token)
    require_role(role, ["admin", "auditor"])

    with engine.connect() as connection:
        result = connection.execute(
            text("""
                SELECT transaction_id, from_account_id, to_account_id, amount, transaction_type, status
                FROM transactions
                LIMIT 5
            """)
        ).mappings().all()

        transactions = []
        for row in result:
            transactions.append({
                "transaction_id": row["transaction_id"],
                "from_account_id": row["from_account_id"],
                "to_account_id": row["to_account_id"],
                "amount": float(row["amount"]),
                "transaction_type": row["transaction_type"],
                "status": row["status"]
            })

        return transactions    

@app.post("/api/v1/transfer")
def transfer_money(
    token: str = Body(...),
    from_account_id: int = Body(...),
    to_account_id: int = Body(...),
    amount: float = Body(...)
):
    role = get_current_user_role(token)
    require_role(role, ["admin", "customer"])

    if amount <= 0:
        raise HTTPException(status_code=400, detail="Amount must be greater than 0")

    if from_account_id == to_account_id:
        raise HTTPException(status_code=400, detail="Cannot transfer to same account")

    try:
        with engine.begin() as connection:
            sender = connection.execute(
                text("SELECT account_id, balance, status FROM accounts WHERE account_id = :id"),
                {"id": from_account_id}
            ).mappings().fetchone()

            receiver = connection.execute(
                text("SELECT account_id, status FROM accounts WHERE account_id = :id"),
                {"id": to_account_id}
            ).mappings().fetchone()

            if sender is None:
                raise HTTPException(status_code=404, detail="Sender account not found")

            if receiver is None:
                raise HTTPException(status_code=404, detail="Receiver account not found")

            if sender["status"] != "active":
                raise HTTPException(status_code=400, detail="Sender account is not active")

            if receiver["status"] != "active":
                raise HTTPException(status_code=400, detail="Receiver account is not active")

            if sender["balance"] < amount:
                raise HTTPException(status_code=400, detail="Insufficient balance")

            connection.execute(
                text("UPDATE accounts SET balance = balance - :amt WHERE account_id = :id"),
                {"amt": amount, "id": from_account_id}
            )

            connection.execute(
                text("UPDATE accounts SET balance = balance + :amt WHERE account_id = :id"),
                {"amt": amount, "id": to_account_id}
            )

            connection.execute(
                text("""
                    INSERT INTO transactions
                    (from_account_id, to_account_id, amount, transaction_type, status)
                    VALUES (:from_id, :to_id, :amt, 'transfer', 'completed')
                """),
                {"from_id": from_account_id, "to_id": to_account_id, "amt": amount}
            )

        return {"message": "Transfer successful"}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))    
        
    
@app.post("/api/v1/withdraw")
def withdraw_money(
    token: str = Body(...),
    account_id: int = Body(...),
    amount: float = Body(...)
):
    role = get_current_user_role(token)
    require_role(role, ["admin", "customer"])

    if amount <= 0:
        raise HTTPException(status_code=400, detail="Amount must be greater than 0")

    try:
        with engine.begin() as connection:
            account = connection.execute(
                text("SELECT account_id, balance, status FROM accounts WHERE account_id = :id"),
                {"id": account_id}
            ).mappings().fetchone()

            if account is None:
                raise HTTPException(status_code=404, detail="Account not found")

            if account["status"] != "active":
                raise HTTPException(status_code=400, detail="Account is not active")

            if account["balance"] < amount:
                raise HTTPException(status_code=400, detail="Insufficient balance")

            connection.execute(
                text("UPDATE accounts SET balance = balance - :amt WHERE account_id = :id"),
                {"amt": amount, "id": account_id}
            )

            connection.execute(
                text("""
                    INSERT INTO transactions
                    (from_account_id, to_account_id, amount, transaction_type, status)
                    VALUES (:from_id, NULL, :amt, 'withdrawal', 'completed')
                """),
                {
                    "from_id": account_id,
                    "amt": amount
                }
            )

        return {"message": "Withdrawal successful"}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    
@app.post("/api/v1/login")
def login_user(
    username: str = Body(...),
    password: str = Body(...)
):
    try:
        with engine.connect() as connection:
            user = connection.execute(
                text("""
                    SELECT user_id, username, password_hash, role
                    FROM users
                    WHERE username = :username
                """),
                {"username": username}
            ).mappings().fetchone()

            if user is None:
                raise HTTPException(status_code=404, detail="User not found")

            if not verify_password(password, user["password_hash"]):
                raise HTTPException(status_code=401, detail="Invalid password")

            token = create_access_token({
                "user_id": user["user_id"],
                "role": user["role"]
            })

            return {
                "message": "Login successful",
                "access_token": token,
                "token_type": "bearer"
            }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    
    
    
    