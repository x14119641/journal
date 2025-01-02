from fastapi import FastAPI, Response, status, HTTPException
from fastapi.params import Body

from .schema import Post, PostOut,PostCreate
from .dependencies import db

import random
app = FastAPI()


fake_data = [{"id": 1, "title": "ttile1", "content":"Some content"}, {"id": 2, "title": "ttile2", "content":"Some content"}]


def find_post(id:int):
    return [row for row in fake_data if row['id'] == id ]

def find_post_index(id:int):
    return [i if row['id'] == id else None for i,row in enumerate(fake_data)  ][0]



@app.on_event("startup")
async def startup():
    # Create the database pool at startup
    await db.create_pool()

@app.on_event("shutdown")
async def shutdown():
    # Close the database pool at shutdown
    await db.close_pool()
    
@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/posts")
async def get_posts():
    results = await db.fetch("SELECT * FROM posts;")
    return {"result": results}   



@app.get("/posts/latest")
async def get_latest_post():
    results = await db.fetchrow("SELECT * FROM posts ORDER BY created_at DESC LIMIT 1;")
    return {"result": results}   


@app.post("/posts", status_code=status.HTTP_201_CREATED, response_model=Post)
async def create_post(post:PostCreate):
    result = await db.fetch(
        """
        INSERT INTO posts (user_id, title, content, published) 
        VALUES ($1, $2, $3, $4) RETURNING id
        """,
        1, post.title, post.content, str(post.published) 
    )
    post_id = result[0]['id'] if result else None
    if post_id is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"post with id: {_id} was not created")
    data = await db.fetchrow("SELECT * FROM posts WHERE id = ($1)", (post_id),)
    return data


@app.post("/posts/{_id}",)
async def get_post(_id:int):
    post = await db.fetchrow("SELECT * FROM posts WHERE id = ($1)", (_id))
    if not post:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"post with id: {_id} was not found")
    return {"result": post}


@app.delete("/posts/{_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(_id:int):
    deleted_post = await db.execute("DELETE FROM posts WHERE id = ($1) returning *", (_id))
    if deleted_post is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail={"result": f"post with id: {_id} does not exists"})
    return Response(status_code=status.HTTP_204_NO_CONTENT)



@app.put("/posts/{_id}", status_code=status.HTTP_202_ACCEPTED)
async def update_post(_id:int, post: PostCreate):
    updated_post = await db.fetchrow("""UPDATE posts 
                                        SET title = ($1), content = ($2), published=($3) 
                                        WHERE id = ($4) returning *""", 
                                        post.title, post.content, str(post.published), _id)
    if updated_post is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail={"result": f"post with id: {_id} does not exists"})
    return {"result": updated_post}