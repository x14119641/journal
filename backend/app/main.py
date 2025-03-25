from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .dependencies import  UnicornException, unicorn_exception_handler
from .routes import post, user, auth, stock, portfolio, transaction


app = FastAPI()

print('¡MAIN!')
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
app.include_router(transaction.router)

app.add_exception_handler(UnicornException, unicorn_exception_handler)

