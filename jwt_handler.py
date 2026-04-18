import os
from jose import jwt, JWTError
from fastapi import HTTPException
from datetime import datetime, timedelta
from dotenv import load_dotenv

load_dotenv()

SECRET_KEY = os.getenv("JWT_SECRET_KEY")
ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("JWT_EXPIRE_MINUTES", 60))

def create_access_token(data: dict):
    if not SECRET_KEY:
        raise HTTPException(status_code=500, detail="JWT secret key not configured")

    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def decode_access_token(token: str):
    if not SECRET_KEY:
        raise HTTPException(status_code=500, detail="JWT secret key not configured")

    return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

def get_current_user_role(token: str):
    try:
        payload = decode_access_token(token)
        role = payload.get("role")
        if role is None:
            raise HTTPException(status_code=401, detail="Role missing in token")
        return role
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid or expired token")