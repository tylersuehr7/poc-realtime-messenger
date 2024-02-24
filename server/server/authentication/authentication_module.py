from injector import Module, singleton, provider

from server.authentication.services.authentication.authentication_service import IAuthenticationService
from server.authentication.services.authentication.authentication_service_impl import AuthenticationServiceImpl
from server.authentication.services.authorization.authorization_service import IAuthorizationService
from server.authentication.services.authorization.authorization_service_impl import AuthorizationServiceImpl


class AuthenticationModule(Module):
    @provider
    @singleton
    def authentication_service(self) -> IAuthenticationService:
        return AuthenticationServiceImpl()

    @provider
    @singleton
    def authorization_service(self) -> IAuthorizationService:
        return AuthorizationServiceImpl()
