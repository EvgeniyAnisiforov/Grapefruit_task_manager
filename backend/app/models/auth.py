from pydantic import BaseModel


class Registration(BaseModel):
    login: str
    passwd: str
    name: str
    surname: str


class AuthenticationRequest(BaseModel):
    login: str
    passwd: str


class AuthenticationResponse(BaseModel):
    id: int
    name: str
    surname: str

