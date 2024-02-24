from uuid import UUID

from django.db.models import QuerySet
from drf_spectacular.utils import extend_schema, inline_serializer
from rest_framework import serializers
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from server.app_injection import injection
from server.messaging.controllers.participant.requests.list_chat_participants_request import ListChatParticipantsRequest
from server.messaging.models import Participant
from server.messaging.serializers.chat_participant_serializer import ChatParticipantSerializer
from server.messaging.services.chat.chat_service import IChatService
from server.messaging.services.participant.params import SearchParticipantsParams
from server.messaging.services.participant.participant_service import IParticipantService
from server.utils.page_number_and_limit_pagination import PageNumberAndLimitPagination


class ListChatParticipantsController(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [JSONParser]
    paginator = PageNumberAndLimitPagination()

    chat_service: IChatService = injection.get(IChatService)
    participant_service: IParticipantService = injection.get(IParticipantService)

    @extend_schema(
        tags=["Participant"],
        operation_id="list_chat_participants",
        parameters=[ListChatParticipantsRequest],
        request=inline_serializer(name="EmptyRequest", fields={}),
        responses={200: inline_serializer(
            name="ListChatParticipantsResponse",
            fields={
                "pev": serializers.CharField(allow_null=True),
                "next": serializers.CharField(allow_null=True),
                "count": serializers.IntegerField(required=True),
                "results": ChatParticipantSerializer(many=True),
            }
        )},
    )
    def get(self, request: Request, chat_id: UUID) -> Response:
        params: SearchParticipantsParams = ListChatParticipantsRequest.parse(request, {"chat_id": chat_id})

        participants: QuerySet[Participant] = self.participant_service.search_participants(params)
        participants = self.paginator.paginate_queryset(participants, request, view=self)

        return self.paginator.get_paginated_response(ChatParticipantSerializer(participants, many=True).data)
