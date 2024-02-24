import uuid

from django.db import models


class Message(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    chat = models.ForeignKey(
        "messaging.Chat",
        on_delete=models.CASCADE,
        related_name="messages",
        help_text="Chat in which this message belongs.",
    )
    author = models.ForeignKey(
        "auth.User",
        on_delete=models.CASCADE,
        related_name="messages",
        help_text="User who is the author of this message.",
    )
    content = models.TextField(
        help_text="Contents of this message.",
    )
    sent_on = models.DateTimeField(
        null=True,
        blank=True,
        help_text="Optional. Timestamp in which this message was sent.",
    )
    delivered_on = models.DateTimeField(
        null=True,
        blank=True,
        help_text="Optional. Timestamp in which this message was delivered.",
    )
    created = models.DateTimeField(
        auto_now_add=True,
    )
    updated = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        verbose_name = "Message"
        verbose_name_plural = "Messages"
        ordering = ["-created"]
