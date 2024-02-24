from django.urls import path

from server.authentication.controllers.identity.controllers import (
    RenewIdentityController,
    AuthenticateIdentityController
)

urlpatterns = [
    path("identity/authenticate", AuthenticateIdentityController.as_view()),
    path("identity/renew", RenewIdentityController.as_view()),
]
