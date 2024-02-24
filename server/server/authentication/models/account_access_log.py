import uuid

from django.db import models


class AccountAccessType(models.TextChoices):
    NEW = "New"
    RENEWED = "Renewed"


class AccountAccessLog(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    account = models.ForeignKey(
        "auth.User",
        on_delete=models.CASCADE,
        help_text="Account that was accessed.",
    )
    access_type = models.CharField(
        max_length=8,
        choices=AccountAccessType.choices,
        help_text="Type of access to account.",
    )
    created = models.DateTimeField(
        auto_now_add=True,
    )

    class Meta:
        verbose_name = "Account Access Log"
        verbose_name_plural = "Account Access Logs"
        ordering = ["-created"]

    def __str__(self) -> str:
        return f"{self.account} accessed on {self.created}"
