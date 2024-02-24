from rest_framework import status

from server.app_errors import AppException


class InvalidRefreshException(AppException):
    status_code = status.HTTP_403_FORBIDDEN

    def __init__(self, message: str):
        super().__init__(
            message=message,
            app_code="invalid_refresh",
        )
