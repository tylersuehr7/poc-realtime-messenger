from typing import AnyStr, cast

from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken

from server.authentication.models import AccountAccessLog
from server.authentication.models.account_access_log import AccountAccessType
from server.authentication.services.authorization.authorization_service import IAuthorizationService
from server.authentication.services.authorization.errors import InvalidRefreshException


class AuthorizationServiceImpl(IAuthorizationService):
    def grant_authorization(self, account: User) -> (AccessToken, RefreshToken):
        refresh_token: RefreshToken = cast(RefreshToken, RefreshToken.for_user(account))
        access_token: AccessToken = refresh_token.access_token

        # Snapshot an account access audit record for new authorization
        AccountAccessLog.objects.create(
            account=account,
            access_type=AccountAccessType.NEW,
        )

        return access_token, refresh_token

    def validate_renewed_authorization(self, access: AnyStr):
        token = AccessToken(token=access, verify=False)
        affected_user_username = token.get("username")
        # affected_user_uid = token.get("user_id")

        try:
            account: User = User.objects.get(username=affected_user_username)
            # account: User = Account.objects.get(pk=affected_user_uid)
        except User.DoesNotExist as e:
            raise InvalidRefreshException("User of this token doesn't seem to exist!") from e

        if not account.is_active:
            raise InvalidRefreshException("Your account is no longer active!")

        # Snapshot an account access audit record for renewed authorization
        AccountAccessLog.objects.create(
            account=account,
            access_type=AccountAccessType.RENEWED,
        )
