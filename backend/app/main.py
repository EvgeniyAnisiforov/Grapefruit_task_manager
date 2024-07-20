import subprocess
import sys
import uvicorn
import logging
from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from app.api.api_routes import router as api_router
from app.config import Config

config = Config()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("main.py")


def create_application() -> FastAPI:
    app = FastAPI()

    app.add_middleware(
        CORSMiddleware,
        allow_origins='*',
        allow_credentials=True,
        allow_methods=["GET", "POST", "PUT", "DELETE"],
        allow_headers=["*"],
    )

    app.include_router(api_router, prefix=config.app.api_prefix)

    return app


def run_tests():
    logger.info("Running tests with coverage...")
    result = subprocess.run([sys.executable, "-m", "pytest", "--cov=app", "--cov-report=term-missing"],
                            capture_output=True)

    stdout = result.stdout.decode()
    stderr = result.stderr.decode()

    if result.returncode == 0:
        logger.info("Tests passed successfully.")
    else:
        logger.error("Tests failed.")

    logger.info("Test Output:\n%s", stdout)
    logger.error("Test Errors:\n%s", stderr)


app = create_application()

if __name__ == "__main__":
    run_tests()

    logger.info("Starting application...")

    uvicorn.run(
        "app.main:app",
        host=config.app.host,
        port=config.app.port,
        reload=False,
        log_level="info"
    )
