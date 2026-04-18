# QuickSave Backend API

## Project Overview
QuickSave is a banking backend API developed for the Advanced Database Management course.  
This backend provides authentication, role-based access control, account access, transaction history, money transfer, and withdrawal functionality using PostgreSQL and FastAPI.

## Technologies Used
- Python
- FastAPI
- PostgreSQL
- SQLAlchemy
- Passlib (bcrypt)
- Python-JOSE (JWT)
- dotenv

## Project Structure

    PROJECT1/
    ├── backend/
    │   ├── auth.py
    │   └── jwt_handler.py
    ├── venv/
    ├── .env
    ├── .env.example
    ├── main.py
    ├── README.md
    ├── swagger.json
    ├── Backend_Explanation.pdf
    ├── schema.sql
    ├── seed.sql
    └── media