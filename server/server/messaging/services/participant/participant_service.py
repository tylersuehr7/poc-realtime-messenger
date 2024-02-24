from abc import ABC, abstractmethod
from uuid import UUID

from django.db.models import QuerySet

from server.messaging.models import Participant
from server.messaging.services.participant.params import SearchParticipantsParams


class IParticipantService(ABC):
    @abstractmethod
    def search_participants(self, params: SearchParticipantsParams) -> QuerySet[Participant]:
        raise NotImplementedError()

    @abstractmethod
    def get_participant_by_id(self, participant_id: UUID) -> Participant:
        raise NotImplementedError()