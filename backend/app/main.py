from fastapi import FastAPI
from fastapi.params import Body

from .schema import Post
import random
app = FastAPI()


fake_data = [{"id": 1, "title": "ttile1", "content":"Some content"}, {"id": 2, "title": "ttile2", "content":"Some content"}]


def find_post(id:int):
    return [row for row in fake_data if row['id'] == id ]


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/posts")
async def get_posts():
    return {"data": fake_data}   



@app.get("/posts/latest")
async def get_latest_post():
    return fake_data[len(fake_data)-1]



@app.post("/posts/{id}")
async def get_post(id:int, post=Post):
    return find_post(id)


@app.post("/posts")
async def create_post(post:Post):
    post_dict = post.dict()
    post_dict['id'] = random.randrange(0, 1000000)
    fake_data.append(post_dict)
    return {"data": post_dict}