from abc import ABC, abstractmethod
from uuid import UUID

from django.db.models import QuerySet

from server.messaging.models import Chat
from server.messaging.services.chat.params import SearchChatsParams


class IChatService(ABC):
    @abstractmethod
    def search_chats(self, params: SearchChatsParams) -> QuerySet[Chat]:
        raise NotImplementedError()

    @abstractmethod
    def get_chat_by_id(self, chat_id: UUID) -> Chat:
        raise NotImplementedError()
