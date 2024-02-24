from rest_framework import serializers
from rest_framework.request import Request

from server.app_injection import injection
from server.messaging.models import Chat
from server.messaging.services.chat.chat_service import IChatService
from server.messaging.services.message.params import SearchMessagesParams
from server.utils.api_request import ApiRequest

_chat_service: IChatService = injection.get(IChatService)


class ListChatMessagesRequest(ApiRequest):
    page = serializers.IntegerField(default=1, required=False)
    limit = serializers.IntegerField(default=20, required=False)

    @classmethod
    def parse(cls, request: Request, path_params: dict = None) -> SearchMessagesParams:
        api_payload: dict = cls._get_payload(request.query_params, path_params)

        chat: Chat = _chat_service.get_chat_by_id(api_payload.get("chat_id"))
        chat.participants.get(user_id=request.user.id)

        return SearchMessagesParams(
            chat=chat,
        )
