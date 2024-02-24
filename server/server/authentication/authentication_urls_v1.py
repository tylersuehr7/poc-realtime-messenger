from django.urls import path, include

from server.authentication.controllers.identity import urls as identity_urls

urlpatterns = [
    path("", include(identity_urls)),
]
