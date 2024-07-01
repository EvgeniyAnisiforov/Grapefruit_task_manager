from fastapi import APIRouter

from backend.app.api.routes import registration

router = APIRouter()
router.include_router(registration.router)

