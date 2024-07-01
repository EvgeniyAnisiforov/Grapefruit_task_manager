from fastapi import APIRouter

from app.api.routes import registration

router = APIRouter()
router.include_router(registration.router)

