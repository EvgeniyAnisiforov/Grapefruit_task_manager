from fastapi import APIRouter, Depends

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    path="/registration",
    description="Метод для пополнения базы запросов из существующего txt файла с патронами",
)
async def registration(

):
    return {'hello':'yes'}
