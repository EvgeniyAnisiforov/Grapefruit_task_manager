from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

from app.db.PostgresRepository import PostgresRepository
from app.exceptions.exceptions import AuthException
from app.main import app
from app.models.auth import AuthenticationResponse
from app.services.AuthService import AuthService
from app.utils.CaptchaData import CAPTCHA_TRUE_CODE

client = TestClient(app)


@pytest.fixture
def get_test_client():
    return client


@pytest.fixture
def postgres_repository():
    return MagicMock(spec=PostgresRepository)


@pytest.fixture
def auth_service(postgres_repository):
    return AuthService(postgres_repository=postgres_repository)


@pytest.mark.asyncio
async def test_registration_user_exists(auth_service, postgres_repository):
    postgres_repository.create_user.return_value = False

    with pytest.raises(AuthException) as exc_info:
        await auth_service.registration(login="new_user", passwd="password", name="John", surname="Doe")

    assert 'User already exist' in str(exc_info.value)
    postgres_repository.create_user.assert_called_once_with(login="new_user", passwd="password", name="John",
                                                            surname="Doe")


@pytest.mark.asyncio
async def test_authentication_success(auth_service, postgres_repository):
    postgres_repository.authorize.return_value = (1, "John", "Doe")

    result = await auth_service.authentication(login="john_doe", passwd="password")

    assert isinstance(result, AuthenticationResponse)
    assert result.id == 1
    assert result.name == "John"
    assert result.surname == "Doe"
    postgres_repository.authorize.assert_called_once_with(login="john_doe", passwd="password")


@pytest.mark.asyncio
async def test_authentication_user_not_found(auth_service, postgres_repository):
    postgres_repository.authorize.return_value = None

    with pytest.raises(AuthException) as exc_info:
        await auth_service.authentication(login="nonexistent_user", passwd="password")

    assert 'User not found' in str(exc_info.value)
    postgres_repository.authorize.assert_called_once_with(login="nonexistent_user", passwd="password")


def test_authentication(get_test_client):
    response = get_test_client.post("/api/auth/authentication", json={
        "login": "ilia",
        "passwd": "python"
    })
    assert response.status_code == 200
    assert 'ilia' in response.json()['name']


def test_get_captcha_url(get_test_client):
    response = get_test_client.get("/api/captcha/get_captcha")
    assert response.status_code == 200
    assert len(response.json()) > 0


def test_verify_captcha(get_test_client):
    response = get_test_client.post("/api/captcha/verify_captcha", json={
        "captcha_code": CAPTCHA_TRUE_CODE
    })
    assert response.status_code == 200
    assert response.json() is True


def test_add_task(get_test_client):
    response = get_test_client.post("/api/kanban/task/add", json={
        "user_id": 18,
        "task": "New Task",
        "level": "1"
    })
    assert response.status_code == 200
    assert "task_id" in response.json()


def test_update_task(get_test_client):
    response = get_test_client.put("/api/kanban/task/update", json={
        "task_id": 28,
        "task": "Updated Task",
        "level": "2"
    })
    assert response.status_code == 200
    assert response.json()["success"] is True


def test_delete_task(get_test_client):
    response = get_test_client.delete("/api/kanban/task/delete", params={"task_id": 1})
    assert response.status_code == 404


def test_get_tasks_by_user_id(get_test_client):
    response = get_test_client.get("/api/kanban/tasks/1")
    assert response.status_code == 200
    assert len(response.json()) > 0


def test_change_task_status(get_test_client):
    response = get_test_client.put("/api/kanban/task/change_status", json={
        "task_id_old": 1,
        "task_id_new": 2
    })
    assert response.status_code == 200
    assert response.json()["success"] is True
