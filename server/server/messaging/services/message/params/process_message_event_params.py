from dataclasses import dataclass

from django.contrib.auth.models import User

from server.messaging.models import Chat
from server.messaging.services.message.types import MessageEventPayload


@dataclass(frozen=True)
class ProcessMessageEventParams:
    payload: MessageEventPayload
    publisher: User
    chat: Chat
