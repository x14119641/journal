from fastapi import FastAPI, Response, status, HTTPException
from fastapi.params import Body
from fastapi.middleware.cors import CORSMiddleware
from .schema import Post, PostOut, PostCreate, User, UserCreate, UserResponse
from .dependencies import oauth2_scheme, password_hash
from typing import List
import random
from .routes import post, user, auth, stock, portfolio


app = FastAPI()


origins = [
    "http://localhost",
    "http://localhost:3000",
    "http://localhost:5173",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials = True,
    allow_methods=["*"],
    allow_headers=["*"], 
)


app.include_router(auth.router)
app.include_router(user.router)
app.include_router(post.router)
app.include_router(stock.router)
app.include_router(portfolio.router)



@app.get("/hello")
async def hello():
    return {"message": "Message from fastapi !!!!"}

@app.get("/")
async def root():
    return {"message": "Hello World"}