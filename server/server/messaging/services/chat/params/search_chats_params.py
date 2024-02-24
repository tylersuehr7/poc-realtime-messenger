from dataclasses import dataclass
from typing import Optional

from django.contrib.auth.models import User


@dataclass(frozen=True)
class SearchChatsParams:
    user: Optional[User] = None
