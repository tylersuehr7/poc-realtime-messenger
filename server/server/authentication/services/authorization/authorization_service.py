from abc import ABC, abstractmethod
from typing import AnyStr

from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken


class IAuthorizationService(ABC):
    @abstractmethod
    def grant_authorization(self, account: User) -> (AccessToken, RefreshToken):
        raise NotImplementedError()

    @abstractmethod
    def validate_renewed_authorization(self, access: AnyStr):
        raise NotImplementedError()
