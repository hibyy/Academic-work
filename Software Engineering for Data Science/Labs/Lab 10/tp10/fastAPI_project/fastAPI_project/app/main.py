from fastapi import Depends, FastAPI, HTTPException, Response, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import logging

from . import crud, models, schemas
from .database import SessionLocal, engine

# Create the database tables
models.Base.metadata.create_all(bind=engine)

# Initialize the FastAPI application
app = FastAPI()

# Enable CORS (Cross-Origin Resource Sharing)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins. You can replace "*" with a list of allowed origins like ['http://localhost']
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (GET, POST, PUT, DELETE, etc.)
    allow_headers=["*"],  # Allows all headers
)

# Dependency to get the database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Get all users
@app.get("/users/", response_model=list[schemas.User])
async def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


# Get a user by ID
@app.get("/users/{user_id}", response_model=schemas.User)
async def get_user_by_id(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


# Update a user
@app.put("/users/{user_id}", response_model=schemas.User)
async def update_user(user_id: int, user: schemas.UserUpdate, db: Session = Depends(get_db)):
    db_user = crud.update_user(db=db, user=user, user_id=user_id)
    return db_user


# Get all posts for a user
@app.get("/users/{user_id}/posts/", response_model=list[schemas.Post])
async def get_user_posts(user_id: int, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    posts = crud.get_user_posts(db, user_id, skip, limit)
    return posts


# Create a new user
@app.post("/users/new", response_model=schemas.User)
async def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)



# Create a new post for a user
@app.post("/users/{user_id}/posts/new", response_model=schemas.Post)
async def create_post_for_user(user_id: int, post: schemas.PostCreate, db: Session = Depends(get_db)):
    logging.info(f"Received POST request for user {user_id} with post data: {post}")
    return crud.create_user_post(db=db, post=post, user_id=user_id)


# Delete a post for a user
@app.delete("/users/{user_id}/delete_post/{post_id}")
async def delete_post_for_user(user_id: int, post_id: int, db: Session = Depends(get_db)):
    db_post = db.query(models.Post).filter(models.Post.author == user_id, models.Post.id == post_id).first()
    if db_post is None:
        raise HTTPException(status_code=404, detail="User or Post not found")
    crud.delete_user_post(db=db, post=db_post)
    return {"msg": "Successfully Deleted"}


# Main entry point for the FastAPI app
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
