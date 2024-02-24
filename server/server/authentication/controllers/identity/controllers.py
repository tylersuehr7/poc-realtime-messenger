from django.contrib.auth.models import User
from drf_spectacular.utils import extend_schema, inline_serializer
from rest_framework import serializers, status
from rest_framework.parsers import JSONParser
from rest_framework.permissions import AllowAny
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenRefreshView

from server.app_injection import injection
from server.authentication.controllers.identity.requests.authenticate_identity_request import (
    AuthenticateIdentityRequest,
)
from server.authentication.controllers.identity.requests.refresh_access_token_request import RefreshAccessTokenRequest
from server.authentication.serializers.user_serializer import UserSerializer
from server.authentication.services.authentication.authentication_service import IAuthenticationService
from server.authentication.services.authentication.params import AuthenticateAccountParams
from server.authentication.services.authorization.authorization_service import IAuthorizationService
from server.authentication.services.authorization.errors import InvalidRefreshException


class AuthenticateIdentityController(APIView):
    permission_classes = [AllowAny]
    parser_classes = [JSONParser]

    authentication_service: IAuthenticationService = injection.get(IAuthenticationService)
    authorization_service: IAuthorizationService = injection.get(IAuthorizationService)

    @extend_schema(
        tags=["Identity"],
        operation_id="authenticate",
        request=AuthenticateIdentityRequest,
        responses={200: inline_serializer(
            name="AuthenticateIdentityResponse",
            fields={
                "access": serializers.CharField(required=True),
                "refresh": serializers.CharField(required=True),
                "account": UserSerializer(required=True),
            }
        )},
    )
    def post(self, request: Request) -> Response:
        params: AuthenticateAccountParams = AuthenticateIdentityRequest.parse(request)
        account: User = self.authentication_service.authenticate_account(params)

        access, refresh = self.authorization_service.grant_authorization(account)

        return Response({
            "access": str(access),
            "refresh": str(refresh),
            "account": UserSerializer(account).data,
        }, status=status.HTTP_200_OK)


class RenewIdentityController(TokenRefreshView):
    """ Proxy API for the underlying TokenRefreshView – so DRF can see this """
    permission_classes = [AllowAny]
    parser_classes = [JSONParser]

    authorization_service: IAuthorizationService = injection.get(IAuthorizationService)

    @extend_schema(
        tags=["Identity"],
        operation_id="renew",
        request=RefreshAccessTokenRequest,
        responses={200: inline_serializer(
            name="RenewIdentityResponse",
            fields={
                "access": serializers.CharField(required=True),
                "refresh": serializers.CharField(required=True),
            }
        )},
    )
    def post(self, request, *args, **kwargs):
        try:
            response = super().post(request, args, kwargs)
        except Exception as e:
            raise InvalidRefreshException("Refresh token expired or invalid!") from e

        access_token = response.data.get("access")
        if access_token:
            self.authorization_service.validate_renewed_authorization(access_token)

        return response
