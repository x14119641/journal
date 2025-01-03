from fastapi import Response, status, HTTPException, APIRouter
from ..schema import (Post, PostBase, PostCreate, PostOut)
from ..dependencies import db, oauth2_scheme, password_hash
from typing import List


router = APIRouter(prefix="/posts", tags=["Posts"]) 


@router.get("/", response_model=List[Post,])
async def get_posts():
    results = await db.fetch("SELECT * FROM posts;")
    if results is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="There are not posts")
    return  results



@router.get("/latest", response_model=Post)
async def get_latest_post():
    results = await db.fetchrow("SELECT * FROM posts ORDER BY created_at DESC LIMIT 1;")
    return results  


@router.post("/", status_code=status.HTTP_201_CREATED, response_model=Post)
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


@router.post("/{_id}", response_model=Post)
async def get_post(_id:int, status_code=status.HTTP_200_OK):
    post = await db.fetchrow("SELECT * FROM posts WHERE id = ($1)", (_id))
    if not post:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"post with id: {_id} was not found")
    return post


@router.delete("/{_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(_id:int):
    deleted_post = await db.execute("DELETE FROM posts WHERE id = ($1) returning *", (_id))
    if deleted_post is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail={"result": f"post with id: {_id} does not exists"})
    return Response(status_code=status.HTTP_204_NO_CONTENT)



@router.put("/{_id}", status_code=status.HTTP_200_OK, response_model=Post)
async def update_post(_id:int, post: PostCreate):
    updated_post = await db.fetchrow("""UPDATE posts 
                                        SET title = ($1), content = ($2), published=($3) 
                                        WHERE id = ($4) returning *""", 
                                        post.title, post.content, str(post.published), _id)
    if updated_post is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail={"result": f"post with id: {_id} does not exists"})
    return updated_post