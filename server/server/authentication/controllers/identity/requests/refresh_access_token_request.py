from rest_framework import serializers
from rest_framework.request import Request

from server.utils.api_request import ApiRequest


class RefreshAccessTokenRequest(ApiRequest):
    refresh = serializers.CharField(max_length=256, required=True)

    @classmethod
    def parse(cls, request: Request, path_params: dict = None):
        raise NotImplementedError()
