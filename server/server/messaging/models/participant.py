import uuid

from django.db import models


class Participant(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    chat = models.ForeignKey(
        "messaging.Chat",
        on_delete=models.CASCADE,
        related_name="participants",
        help_text="Chat in which this participant belongs.",
    )
    user = models.ForeignKey(
        "auth.User",
        on_delete=models.CASCADE,
        related_name="participants",
        help_text="User in which this participant represents.",
    )
    created = models.DateTimeField(
        auto_now_add=True,
    )
    updated = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        verbose_name = "Participant"
        verbose_name_plural = "Participants"
        ordering = ["-created"]

    @property
    def is_chat_owner(self) -> bool:
        return self.chat.owner_id == self.user_id
