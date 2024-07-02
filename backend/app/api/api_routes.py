from fastapi import APIRouter

from app.api.routes import auth, kanban

router = APIRouter()
router.include_router(auth.router)
router.include_router(kanban.router)

