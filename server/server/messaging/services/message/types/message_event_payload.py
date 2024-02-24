from dataclasses import dataclass
from enum import Enum


class MessageEventName(str, Enum):
    NEW_MESSAGE = "new_message"
    EDIT_MESSAGE = "edit_message"
    DELETE_MESSAGE = "delete_message"
    PURGE = "purge"


@dataclass(frozen=True)
class MessageEventPayload:
    event_name: MessageEventName
    data: dict
