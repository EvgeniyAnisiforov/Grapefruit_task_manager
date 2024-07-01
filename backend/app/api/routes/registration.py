from fastapi import APIRouter, Depends
from app.dependencies.db import get_repository

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    path="/registration",
    description="Метод для пополнения базы запросов из существующего txt файла с патронами",
)
async def registration(
        repo=Depends(get_repository)
):
    return repo.authorize("ilia", "python")
