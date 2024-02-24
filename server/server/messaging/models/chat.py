import uuid

from django.db import models


class Chat(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    name = models.CharField(
        max_length=128,
        help_text="Human-readable name of this chat.",
    )
    owner = models.ForeignKey(
        "auth.User",
        on_delete=models.PROTECT,
        related_name="owned_chats",
        help_text="User who is considered the owner of this chat.",
    )
    created = models.DateTimeField(
        auto_now_add=True,
    )
    updated = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        verbose_name = "Chat"
        verbose_name_plural = "Chats"
        ordering = ["-created"]

    @property
    def is_group_chat(self) -> bool:
        return self.participants.count() > 2
