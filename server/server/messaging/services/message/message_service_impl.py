from typing import Optional
from uuid import UUID

from django.db.models import QuerySet
from django.utils import timezone

from server.messaging.models import Message, Participant
from server.messaging.services.message.message_service import IMessageService
from server.messaging.services.message.params import SearchMessagesParams
from server.messaging.services.message.params.process_message_event_params import ProcessMessageEventParams
from server.messaging.services.message.types import MessageEventName


class MessageServiceImpl(IMessageService):
    def search_messages(self, params: SearchMessagesParams) -> QuerySet[Message]:
        query: QuerySet[Message] = Message.objects.all()

        if params.chat:
            query = query.filter(chat_id=params.chat.id)
        if params.author:
            query = query.filter(author_id=params.author.id)

        return query

    def get_message_by_id(self, message_id: UUID) -> Message:
        return Message.objects.get(pk=message_id)

    def process_message_event(self, params: ProcessMessageEventParams):
        participant: Optional[Participant] = params.chat.participants.filter(user_id=params.publisher.id).first()

        # Validate that the publisher has access to the chat
        if not participant:
            raise PermissionError("You do not have access to this chat!")

        if MessageEventName.NEW_MESSAGE == params.payload.event_name:
            Message.objects.create(
                id=params.payload.data["id"],
                chat=params.chat,
                author=params.publisher,
                content=params.payload.data["content"],
                sent_on=params.payload.data["sent_on"],
                delivered_on=timezone.now(),
            )
        elif MessageEventName.EDIT_MESSAGE == params.payload.event_name:
            # TODO validate permissions for editing messages
            message = Message.objects.get(pk=params.payload.data["id"])
            message.content = params.payload.data["content"]
            message.save()
        elif MessageEventName.DELETE_MESSAGE == params.payload.event_name:
            # TODO validate permissions for deleting messages
            message = Message.objects.get(pk=params.payload.data["id"])
            message.delete()
