from abc import ABC, abstractmethod

from django.contrib.auth.models import User

from server.authentication.services.authentication.params import AuthenticateAccountParams


class IAuthenticationService(ABC):
    @abstractmethod
    def authenticate_account(self, params: AuthenticateAccountParams) -> User:
        raise NotImplementedError()
