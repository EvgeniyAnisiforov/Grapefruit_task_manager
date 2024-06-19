# # from app.api.routes.api import router as api_router
#
#
# def create_application() -> FastAPI:
#     app = FastAPI()
#
#     app.add_middleware(
#         CORSMiddleware,
#         allow_origins='*',
#         allow_credentials=True,
#         allow_methods=["GET", "POST", "PUT", "DELETE"],
#         allow_headers=["*"],
#     )
#
#
#     app.include_router(api_router, prefix=config.app.api_prefix)
#
#
#     return app
#
#
# app = create_application()
#
#
# if __name__ == "__main__":
#     uvicorn.run(
#         "app.main:app",
#         host=config.app.host,
#         port=config.app.port,
#         workers=1,
#         reload=False,
#         log_level="info"
#     )
