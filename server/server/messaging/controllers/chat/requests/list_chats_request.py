from rest_framework import serializers
from rest_framework.request import Request

from server.messaging.services.chat.params import SearchChatsParams
from server.utils.api_request import ApiRequest


class ListChatsRequest(ApiRequest):
    page = serializers.IntegerField(default=1, required=False)
    limit = serializers.IntegerField(default=20, required=False)

    @classmethod
    def parse(cls, request: Request, path_params: dict = None) -> SearchChatsParams:
        return SearchChatsParams(
            user=request.user,
        )
