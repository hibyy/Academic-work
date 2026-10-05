from pydantic import BaseModel, ConfigDict
import datetime

# Create Pydantic Base models with common attributes while creating or reading data.


class PostBase(BaseModel):
    publishedAt: datetime.datetime
    title: str
    content: str


class UserBase(BaseModel):
    name: str
    email: str

# Create Pydantic models that will be used when reading data (returning it from the API).


class Post(PostBase):
    id: int
    author: int

    # Updated to use ConfigDict for ORM compatibility
    model_config = ConfigDict(from_attributes=True)


class User(UserBase):
    id: int

    # Updated to use ConfigDict for ORM compatibility
    model_config = ConfigDict(from_attributes=True)

# Create Pydantic models needed for creation purposes


class PostCreate(PostBase):
    pass


class UserCreate(UserBase):
    posts: list[Post] = []
    pass


class UserUpdate(UserBase):
    pass
