from typing import Optional

from django.contrib.auth.models import User

from server.authentication.services.authentication.authentication_service import IAuthenticationService
from server.authentication.services.authentication.errors import InvalidLoginException
from server.authentication.services.authentication.params import AuthenticateAccountParams


class AuthenticationServiceImpl(IAuthenticationService):
    def authenticate_account(self, params: AuthenticateAccountParams) -> User:
        account: Optional[User] = User.objects.filter(username=params.username).first()

        if not account or not account.check_password(params.password) or not account.is_active:
            raise InvalidLoginException()

        return account
