from app.db.PostgresRepository import PostgresRepository
from app.exceptions.exceptions import AuthException
from app.models.auth import AuthenticationResponse


class AuthService:
    def __init__(
            self,
            postgres_repository: PostgresRepository
    ):
        self.postgres_repository = postgres_repository

    async def registration(self, login: str, passwd: str, name: str, surname: str) -> bool:
        reg_result = self.postgres_repository.create_user(
            login=login, passwd=passwd, name=name, surname=surname
        )
        if reg_result:
            return reg_result
        else:
            raise AuthException('User already exist')

    async def authentication(self, login: str, passwd: str) -> AuthenticationResponse:
        auth_result = self.postgres_repository.authorize(login=login, passwd=passwd)
        if auth_result:
            return AuthenticationResponse(
                id=auth_result[0], name=auth_result[1], surname=auth_result[2]
            )
        else:
            raise AuthException('User not found')

