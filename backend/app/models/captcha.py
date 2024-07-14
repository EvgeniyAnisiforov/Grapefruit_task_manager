from pydantic import BaseModel


class CaptchaPicture(BaseModel):
    id: str
    img: str


class CaptchaRequest(BaseModel):
    captcha_code: str

