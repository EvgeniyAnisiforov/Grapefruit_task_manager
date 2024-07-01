from fastapi import HTTPException
from fastapi import status


class NotFoundException(HTTPException):
    def __init__(self, object_name: str):
        self.status_code = status.HTTP_404_NOT_FOUND
        self.detail = f"{object_name} not found"


class ValidationException(HTTPException):
    def __init__(self, message: str):
        self.status_code = status.HTTP_400_BAD_REQUEST
        self.detail = message

