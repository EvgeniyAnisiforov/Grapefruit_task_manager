from app.config import Config
from app.db.PostgresRepository import PostgresRepository

config = Config()


def get_postgres_repository():
    return PostgresRepository(
        database=config.postgres.db,
        user=config.postgres.user,
        password=config.postgres.password,
        host=config.postgres.host,
        port=config.postgres.port
    )

