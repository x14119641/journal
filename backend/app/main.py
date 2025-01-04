from fastapi import FastAPI, Response, status, HTTPException
from fastapi.params import Body
from fastapi.middleware.cors import CORSMiddleware
from .schema import Post, PostOut, PostCreate, User, UserCreate, UserResponse
from .dependencies import db, oauth2_scheme, password_hash
from typing import List
import random
from .routes import post, user, auth


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

@app.on_event("startup")
async def startup():
    # Create the database pool at startup
    await db.create_pool()

@app.on_event("shutdown")
async def shutdown():
    # Close the database pool at shutdown
    await db.close_pool()

app.include_router(auth.router)
app.include_router(user.router)
app.include_router(post.router)



@app.get("/hello")
async def hello():
    return {"message": "Message from fastapi !!!!"}

@app.get("/")
async def root():
    return {"message": "Hello World"}