from fastapi import FastAPI, Response, status, HTTPException
from fastapi.params import Body

from .schema import Post
import random
app = FastAPI()


fake_data = [{"id": 1, "title": "ttile1", "content":"Some content"}, {"id": 2, "title": "ttile2", "content":"Some content"}]


def find_post(id:int):
    return [row for row in fake_data if row['id'] == id ]

def find_post_index(id:int):
    return [i if row['id'] == id else None for i,row in enumerate(fake_data)  ][0]


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/posts")
async def get_posts():
    return {"data": fake_data}   



@app.get("/posts/latest")
async def get_latest_post():
    return fake_data[len(fake_data)-1]



@app.post("/posts/{id}",)
async def get_post(id:int):
    post = find_post(id)
    if not post:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"post with id: {id} was not found")
    return {"result": post}


@app.post("/posts", status_code=status.HTTP_201_CREATED)
async def create_post(post:Post):
    post_dict = post.dict()
    post_dict['id'] = random.randrange(0, 1000000)
    fake_data.append(post_dict)
    return {"data": post_dict}


@app.delete("/posts/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(id:int):
    index = find_post_index(i)
    if index is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail={"result": f"post with id: {id} does not exists"})
    fake_data.pop(index)
    return Response(status_code=status.HTTP_204_NO_CONTENT)



@app.put("/posts/{id}", status_code=status.HTTP_202_ACCEPTED)
async def update_post(id:int, post: Post):
    index = find_post_index(id)
    if index is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail={"result": f"post with id: {id} does not exists"})
    fake_data[index]['title'] = post.title 
    fake_data[index]['content'] = post.content
    result = fake_data[index]
    return {"result": result}