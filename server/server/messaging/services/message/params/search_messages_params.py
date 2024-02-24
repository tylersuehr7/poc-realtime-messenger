from dataclasses import dataclass
from typing import Optional

from django.contrib.auth.models import User

from server.messaging.models import Chat


@dataclass(frozen=True)
class SearchMessagesParams:
    chat: Optional[Chat] = None
    author: Optional[User] = None
