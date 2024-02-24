import logging

from django.core.exceptions import ObjectDoesNotExist, BadRequest
from django.core.exceptions import PermissionDenied as DjangoPermissionDenied
from django.utils import timezone
from rest_framework import serializers
from rest_framework import status
from rest_framework.exceptions import APIException, PermissionDenied
from rest_framework.response import Response
from rest_framework.views import exception_handler

logger = logging.getLogger(__name__)


class AppErrorSerializer(serializers.Serializer):
    """Normalized application error API response."""
    app_code = serializers.CharField(required=True, allow_null=True)
    status_code = serializers.IntegerField(min_value=100, max_value=599, required=True)
    message = serializers.CharField(required=True)
    timestamp = serializers.DateTimeField(default=timezone.now())


class AppThrowable(Exception):
    """Base throwable object for all supported aether error types."""
    status_code: int = status.HTTP_500_INTERNAL_SERVER_ERROR

    def __init__(self, message: str, app_code: str = None, debug_data: dict = None):
        super().__init__(message)
        self.message = message
        self.app_code = app_code
        self.debug_data = debug_data

    def __str__(self):
        if self.app_code:
            return f"[{self.app_code}] {self.message}"
        return self.message


class AppException(AppThrowable):
    """
    Base exception for application logic.

    An "AppException" is treated as a permitted excepted case from a
    logical computational flow of operations that breaks the flow. In other
    words, it is a permitted case that bypasses the normal flow of a routine.

    An example of its usage could be a runtime error thrown when attempting to change
    a user's password due to the supplied old password being incorrect. In such a case,
    this is not a programming fault that requires a fix, but it does break the logical
    flow of the user changing their password and should not continue the routine.
    """
    status_code: int = status.HTTP_422_UNPROCESSABLE_ENTITY


class AppError(AppThrowable):
    """
    Base error for application login.

    An "AppError" is treated as a non-permitted case from a logical computational
    flow of operations that breaks the flow. This usually implies a programming error
    or some other fault that requires a logical fix or correction to prevent this kind
    of error from being thrown again.

    An example of its usage could be runtime error thrown when a routine accesses a field
    on an object that is `null` – a.k.a. Null Pointer – and therefore requires a logical fix
    to prevent such access from occurring again.
    """
    def __init__(self, message: str, debug_data: dict = None):
        super().__init__(message, None, debug_data)


def custom_exception_handler(ex, context) -> Response:
    logger.exception(ex)
    response = exception_handler(ex, context)
    response_data: dict = {}

    if isinstance(ex, AppError):
        response_data["app_code"] = None
        response_data["status_code"] = ex.status_code
        response_data["message"] = ex.message
    elif isinstance(ex, AppException):
        response_data["app_code"] = ex.app_code
        response_data["status_code"] = ex.status_code
        response_data["message"] = ex.message
    elif isinstance(ex, ObjectDoesNotExist):
        response_data["app_code"] = None
        response_data["status_code"] = status.HTTP_404_NOT_FOUND
        response_data["message"] = "Object does not seem to exist!"
    elif isinstance(ex, BadRequest):
        response_data["app_code"] = None
        response_data["status_code"] = status.HTTP_400_BAD_REQUEST
        response_data["message"] = "Malformed or bad request! Please fix and try again!"
    elif isinstance(ex, DjangoPermissionDenied) or isinstance(ex, PermissionDenied) or isinstance(ex, PermissionError):
        response_data["app_code"] = "permission_denied"
        response_data["status_code"] = status.HTTP_403_FORBIDDEN
        response_data["message"] = "You do not have permission to perform this action."
    elif isinstance(ex, APIException):
        response_data["app_code"] = None
        response_data["status_code"] = ex.status_code
        response_data["message"] = ex.default_detail
    else:
        response_data["app_code"] = None
        response_data["status_code"] = status.HTTP_500_INTERNAL_SERVER_ERROR
        response_data["message"] = "An unexpected error occurred, please try again!"

    serialized_data = AppErrorSerializer(response_data).data
    if response:
        return Response(serialized_data, status=response.status_code, headers=response.headers)

    return Response(serialized_data, status=response_data["status_code"])
