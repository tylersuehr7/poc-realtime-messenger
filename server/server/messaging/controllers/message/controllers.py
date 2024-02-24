from uuid import UUID

from django.db.models import QuerySet
from drf_spectacular.utils import extend_schema, inline_serializer
from rest_framework import serializers, status
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.app_injection import injection
from server.messaging.controllers.message.requests.list_chat_messages_request import ListChatMessagesRequest
from server.messaging.models import Message
from server.messaging.serializers.message_serializer import MessageSerializer
from server.messaging.services.chat.chat_service import IChatService
from server.messaging.services.message.message_service import IMessageService
from server.messaging.services.message.params import SearchMessagesParams
from server.messaging.services.participant.participant_service import IParticipantService
from server.utils.page_number_and_limit_pagination import PageNumberAndLimitPagination


class ListChatMessagesController(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [JSONParser]
    paginator = PageNumberAndLimitPagination()

    chat_service: IChatService = injection.get(IChatService)
    participant_service: IParticipantService = injection.get(IParticipantService)
    message_service: IMessageService = injection.get(IMessageService)

    @extend_schema(
        tags=["Message"],
        operation_id="list_chat_messages",
        parameters=[ListChatMessagesRequest],
        request=inline_serializer(name="EmptyRequest", fields={}),
        responses={200: inline_serializer(
            name="ListChatMessagesResponse",
            fields={
                "pev": serializers.CharField(allow_null=True),
                "next": serializers.CharField(allow_null=True),
                "count": serializers.IntegerField(required=True),
                "results": MessageSerializer(many=True),
            }
        )},
    )
    def get(self, request: Request, chat_id: UUID) -> Response:
        params: SearchMessagesParams = ListChatMessagesRequest.parse(request, {"chat_id": chat_id})

        messages: QuerySet[Message] = self.message_service.search_messages(params)
        messages = self.paginator.paginate_queryset(messages, request, view=self)

        return self.paginator.get_paginated_response(MessageSerializer(messages, many=True).data)


class GetChatMessageController(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [JSONParser]

    message_service: IMessageService = injection.get(IMessageService)

    @extend_schema(
        tags=["Message"],
        operation_id="get_chat_message",
        parameters=[],
        request=inline_serializer(name="EmptyRequest", fields={}),
        responses={200: inline_serializer(
            name="GetChatMessageResponse",
            fields={
                "message": MessageSerializer(required=True),
            }
        )},
    )
    def get(self, request: Request, message_id: UUID) -> Response:
        message: Message = self.message_service.get_message_by_id(message_id)
        message.chat.participants.get(user_id=request.user.id)
        return Response({
            "message": MessageSerializer(message).data,
        }, status=status.HTTP_200_OK)
