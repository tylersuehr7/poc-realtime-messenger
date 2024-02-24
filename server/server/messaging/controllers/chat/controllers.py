from django.db.models import QuerySet
from drf_spectacular.utils import extend_schema, inline_serializer
from rest_framework import serializers
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.app_injection import injection
from server.messaging.controllers.chat.requests.list_chats_request import ListChatsRequest
from server.messaging.models import Chat
from server.messaging.serializers.chat_serializer import ChatSerializer
from server.messaging.services.chat.chat_service import IChatService
from server.messaging.services.chat.params import SearchChatsParams
from server.utils.page_number_and_limit_pagination import PageNumberAndLimitPagination


class ListChatsController(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [JSONParser]
    paginator = PageNumberAndLimitPagination()

    chat_service: IChatService = injection.get(IChatService)

    @extend_schema(
        tags=["Chat"],
        operation_id="list_chats",
        parameters=[ListChatsRequest],
        request=inline_serializer(name="EmptyRequest", fields={}),
        responses={200: inline_serializer(
            name="ListChatsResponse",
            fields={
                "pev": serializers.CharField(allow_null=True),
                "next": serializers.CharField(allow_null=True),
                "count": serializers.IntegerField(required=True),
                "results": ChatSerializer(many=True),
            }
        )},
    )
    def get(self, request: Request) -> Response:
        params: SearchChatsParams = ListChatsRequest.parse(request)

        chats: QuerySet[Chat] = self.chat_service.search_chats(params)
        chats = self.paginator.paginate_queryset(chats, request, view=self)

        return self.paginator.get_paginated_response(ChatSerializer(chats, many=True).data)
