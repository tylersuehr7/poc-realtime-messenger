from uuid import UUID

from django.db.models import QuerySet

from server.messaging.models import Participant
from server.messaging.services.participant.params import SearchParticipantsParams
from server.messaging.services.participant.participant_service import IParticipantService


class ParticipantServiceImpl(IParticipantService):
    def search_participants(self, params: SearchParticipantsParams) -> QuerySet[Participant]:
        query: QuerySet[Participant] = Participant.objects.all()

        if params.chat:
            query = query.filter(chat_id=params.chat.id)
        if params.user:
            query = query.filter(user_id=params.user.id)

        return query

    def get_participant_by_id(self, participant_id: UUID) -> Participant:
        return Participant.objects.get(pk=participant_id)
