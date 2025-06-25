from pydantic import BaseModel

class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    role: str  # 'student' or 'teacher'
    reg_id: str

class UserOut(BaseModel):
    id: int
    name: str
    email: str
    role: str
    reg_id: str

    class Config:
        orm_mode = True

class Token(BaseModel):
    access_token: str
    token_type: str
