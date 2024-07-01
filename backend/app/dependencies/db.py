from backend.app.config import Config
from backend.app.db.PostgreRepository import Database

config = Config()


def get_repository():
    return Database(
        database=config.postgres.db,
        user=config.postgres.user,
        password=config.postgres.password,
        host=config.postgres.host,
        port=config.postgres.port
    )

