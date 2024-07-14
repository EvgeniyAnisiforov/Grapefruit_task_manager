from fastapi import APIRouter

from app.api.routes import auth, kanban, captcha

router = APIRouter()
router.include_router(auth.router)
router.include_router(kanban.router)
router.include_router(captcha.router)

