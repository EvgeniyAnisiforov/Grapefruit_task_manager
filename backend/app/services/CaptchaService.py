import random

from app.models.captcha import CaptchaPicture
from app.utils.CaptchaData import CAPTCHA, CAPTCHA_TRUE_CODE


class CaptchaService:
    def __init__(
            self
    ):
        pass

    @staticmethod
    async def get_captcha() -> list[CaptchaPicture]:
        captcha = CAPTCHA.copy()
        random.shuffle(captcha)
        return captcha

    async def verify_captcha(self, captcha_code: str):
        if CAPTCHA_TRUE_CODE == captcha_code:
            return True
        else:
            return await self.get_captcha()

