from fastapi import Depends, status, HTTPException, APIRouter, BackgroundTasks, Request,Header
from ..dependencies import get_db, password_hash, secrets, oauth2_scheme
from ..schema import (Post, PostCreate, RefreshToken, ResetPasswordRequest, User, UserCreate, UserResponse, UserLogin,
                     Token, TokenData)
from ..services import email_service
from ..services.database import Database
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from typing import List, Annotated
from jwt.exceptions import InvalidTokenError
from datetime import datetime, timedelta, timezone
import jwt

router = APIRouter(tags=['Authentification'])

 
async def get_user(username: str) -> UserLogin:
    """Gets user by username or email from db.

    Args:
        username (str): username or email of user.

    Returns:
        UserLogin: A Pydantic model representing the user data.
    """
    async for db in get_db():
        data = await db.fetchrow("SELECT * FROM users WHERE username = ($1) OR email = ($2)", username, username)
        if data:
            return UserLogin(**data)


def verify_password(plain_password, hashed_password):
    return password_hash.verify(plain_password, hashed_password)

def get_password_hash(password):
    return password_hash.hash(password)


async def authenticate_user(username:str, password:str)->User:
    """Checks if username exists and passowrd is correct

    Args:
        username (str)
        password (str)

    Returns:
        _type_: User if user exists otherwise False.
    """
    user = await get_user(username)
    if not user:    
        return False
    if not verify_password(password, user.password):
        return False
    return user 


def create_access_token(data:dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(days=1)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, secrets.SECRET_KEY, algorithm=secrets.ALGORITHM)
    return encoded_jwt

def create_refresh_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(days=7)  
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, secrets.REFRESH_SECRET_KEY, algorithm=secrets.ALGORITHM)
    return encoded_jwt


async def get_current_user(token:Annotated[str, Depends(oauth2_scheme)]):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate Credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, secrets.SECRET_KEY, algorithms=[secrets.ALGORITHM])
        username:str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except InvalidTokenError:
        raise credentials_exception
    user = await get_user(username=token_data.username)
    if user is None:
        raise credentials_exception
    return user

async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)],
):
    if current_user.disabled:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Inactive User")
    return current_user


@router.post("/login")
async def login(request: Request, # To get data form person trying to login
                form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
                db: Annotated[Database, Depends(get_db)]) -> Token:

    print("form_data in login: ", form_data.username)
    user = await authenticate_user(form_data.username, form_data.password)
    user_agent = request.headers.get("user-agent")
    ip_address = request.headers.get("x-forwarded-for", request.client.host)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes= secrets.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    refresh_token_expires = timedelta(days=7)
    refresh_token = create_refresh_token(
        data={"sub": user.username}, expires_delta=refresh_token_expires
    )
    # INsert into Token
    expires_at = datetime.now(timezone.utc) + refresh_token_expires
    await db.execute(
        """
        INSERT INTO refresh_tokens (user_id, token, expires_at, ip_address, user_agent)
        VALUES ($1, $2, $3, $4, $5)
        """,
        user.id, refresh_token, expires_at, ip_address, user_agent
    )
    return Token(access_token=access_token, token_type="bearer", refresh_token=refresh_token)


@router.post("/refresh")
async def refresh_token(
    request: Request,
    token_data: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[Database, Depends(get_db)]
) -> Token:
    user_agent = request.headers.get("user-agent")
    ip_address = request.headers.get("x-forwarded-for", request.client.host)

    print("🔁 /refresh called")
    print("Raw token:", token_data)

    try:
        payload = jwt.decode(token_data, secrets.REFRESH_SECRET_KEY, algorithms=[secrets.ALGORITHM])
        username = payload.get('sub')
        print("Decoded payload:", payload)
    except Exception as e:
        print("❌ JWT decode failed:", str(e))
        raise HTTPException(status_code=401, detail="Invalid refresh token")

    row = await db.fetchrow("SELECT * FROM refresh_tokens WHERE token = $1 AND revoked = FALSE", token_data)
    print("DB token found:", row)


    # Check if refresh token is valid and not revoked
    row = await db.fetchrow(
        "SELECT * FROM refresh_tokens WHERE token = $1 AND revoked = FALSE",
        token_data
    )
    if not row:
        raise HTTPException(status_code=401, detail="Refresh token is invalid or revoked")

    user = await get_user(username)
    if not user:
        raise HTTPException(status_code=401, detail="User not found")

    # Revoke old refresh tokens (optional but recommended)
    await db.execute(
        "UPDATE refresh_tokens SET revoked = TRUE WHERE user_id = $1 AND token = $2",
        user.id, token_data
    )

    # Issue new tokens
    access_token_expires = timedelta(minutes=secrets.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )

    refresh_token_expires = timedelta(days=7)
    new_refresh_token = create_refresh_token(
        data={"sub": user.username}, expires_delta=refresh_token_expires
    )
    expires_at = datetime.now(timezone.utc) + refresh_token_expires

    await db.execute(
        """
        INSERT INTO refresh_tokens (user_id, token, expires_at, ip_address, user_agent)
        VALUES ($1, $2, $3, $4, $5)
        """,
        user.id, new_refresh_token, expires_at, ip_address, user_agent
    )

    return Token(
        access_token=access_token,
        token_type="bearer",
        refresh_token=new_refresh_token
    )

@router.post("/forgot-password")
async def forgot_password(transaction:ResetPasswordRequest, background_tasks: BackgroundTasks, db: Annotated[Database, Depends(get_db)]):
    user = await db.fetchrow("SELECT * FROM users WHERE email =$1", transaction.email)
    print('USER: ', user)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    reset_token = create_access_token(
        data={"sub": user['username']},
        expires_delta=timedelta(minutes=15)
    )
    reset_link = f"http://localhost:5173/reset-password?token={reset_token}"
    background_tasks.add_task(email_service.send_reset_email, transaction.email, reset_link)
    print('EMail SENT')
    return {"message": "If that email exists, a reset link was sent."}


@router.post("/reset-password")
async def reset_password(
    password: str,
    request: Request,
    db: Annotated[Database, Depends(get_db)],) -> Token:
    auth_header = request.headers.get("authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing token")

    token = auth_header.split(" ")[1]

    try:
        payload = jwt.decode(token, secrets.SECRET_KEY, algorithms=[secrets.ALGORITHM])
        username = payload.get("sub")
        if not username:
            raise HTTPException(status_code=401, detail="Invalid token")
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    

    user = await get_user(username)
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    
    hashed_pwd = password_hash.hash(password)
    updated_user  = await db.fetchrow(
        "UPDATE users SET password = $1 WHERE user_id = $2 RETURNING *",
        hashed_pwd, user.id
    )
    if not updated_user:
        raise HTTPException(status_code=500, detail="Failed to update password")
    
    user_agent = request.headers.get("user-agent")
    ip_address = request.headers.get("x-forwarded-for", request.client.host)
    
    access_token_expires = timedelta(minutes=60)
    access_token = create_access_token(
        data={"sub": username}, expires_delta=access_token_expires
    )
    refresh_token_expires = timedelta(days=7)
    refresh_token = create_refresh_token(
        data={"sub": username}, expires_delta=refresh_token_expires
    )
    # INsert into Token
    expires_at = datetime.now(timezone.utc) + refresh_token_expires
    await db.execute(
        """
        INSERT INTO refresh_tokens (user_id, token, expires_at, ip_address, user_agent)
        VALUES ($1, $2, $3, $4, $5)
        """,
        user.id, refresh_token, expires_at, ip_address, user_agent
    )
    return Token(access_token=access_token, token_type="bearer", refresh_token=refresh_token)


@router.post("/logout")
async def logout(
    payload:RefreshToken,
    current_user: Annotated[UserLogin, Depends(get_current_active_user)],
    db: Annotated[Database, Depends(get_db)],
):

    # Delete or revoke token
    await db.execute(
        "UPDATE  refresh_tokens SET revoked=True WHERE user_id = $1 AND token = $2",
        current_user.id, payload.refresh_token
    )
    print(f"Logging out token: {payload.refresh_token}")

    return {"message": "Successfully logged out"}