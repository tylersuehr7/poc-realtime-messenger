from abc import ABC, abstractmethod
from uuid import UUID

from django.db.models import QuerySet

from server.messaging.models import Message
from server.messaging.services.message.params import SearchMessagesParams, ProcessMessageEventParams


class IMessageService(ABC):
    @abstractmethod
    def search_messages(self, params: SearchMessagesParams) -> QuerySet[Message]:
        raise NotImplementedError()

    @abstractmethod
    def get_message_by_id(self, message_id: UUID) -> Message:
        raise NotImplementedError()

    @abstractmethod
    def process_message_event(self, params: ProcessMessageEventParams):
        raise NotImplementedError()
