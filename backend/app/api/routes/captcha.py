from fastapi import APIRouter, Depends
from typing_extensions import List

from app.dependencies.services import get_captcha_service
from app.models.captcha import CaptchaRequest, CaptchaPicture

router = APIRouter(prefix="/captcha", tags=["captcha"])


@router.get(
    path="/get_captcha",
    description="Метод для получения капчи",
    response_model=List[CaptchaPicture]
)
async def get_captcha(
        captcha_service=Depends(get_captcha_service)
):
    captcha = await captcha_service.get_captcha()
    return captcha


@router.post(
    path="/verify_captcha",
    description="Метод для проверки капчи",
)
async def verify_captcha(
        request: CaptchaRequest,
        captcha_service=Depends(get_captcha_service)
):
    verify_captcha_result = await captcha_service.verify_captcha(request.captcha_code)
    return verify_captcha_result
