from fastapi import APIRouter, Depends

from app.dependencies.services import get_auth_service
from app.models.auth import AuthenticationRequest, Registration

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    path="/registration",
    description="Метод для регистрации пользователя",
)
async def registration(
        request: Registration,
        auth_service=Depends(get_auth_service)
):
    user_info = await auth_service.registration(
        request.login, request.passwd, request.name, request.surname
    )
    return user_info


@router.post(
    path="/authentication",
    description="Метод для aвторизации пользователя",
)
async def authentication(
        request: AuthenticationRequest,
        auth_service=Depends(get_auth_service)
):
    auth_result = await auth_service.authentication(request.login, request.passwd)
    return auth_result

