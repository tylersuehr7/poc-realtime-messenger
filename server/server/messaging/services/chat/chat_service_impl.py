from uuid import UUID

from django.db.models import QuerySet

from server.messaging.models import Chat
from server.messaging.services.chat.chat_service import IChatService
from server.messaging.services.chat.params import SearchChatsParams


class ChatServiceImpl(IChatService):
    def search_chats(self, params: SearchChatsParams) -> QuerySet[Chat]:
        query: QuerySet[Chat] = Chat.objects.all()

        if params.user:
            query = query.filter(participants__user_id=params.user.id)

        return query

    def get_chat_by_id(self, chat_id: UUID) -> Chat:
        return Chat.objects.get(pk=chat_id)
