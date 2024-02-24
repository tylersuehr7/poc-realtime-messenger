from server.app_errors import AppException


class InvalidLoginException(AppException):
    def __init__(self):
        super().__init__(
            message="Invalid login attempt!",
            app_code="invalid_login",
        )
