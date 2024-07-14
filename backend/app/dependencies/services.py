from fastapi import Depends

from app.dependencies.db import get_postgres_repository
from app.services.AuthService import AuthService
from app.services.CaptchaService import CaptchaService
from app.services.KanbanService import KanbanService


def get_auth_service(
        postgres_repository=Depends(get_postgres_repository)
):
    return AuthService(postgres_repository=postgres_repository)


def get_kanban_service(
        postgres_repository=Depends(get_postgres_repository)
):
    return KanbanService(postgres_repository=postgres_repository)


def get_captcha_service(

):
    return CaptchaService()

