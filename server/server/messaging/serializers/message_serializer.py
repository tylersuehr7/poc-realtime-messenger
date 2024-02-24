from rest_framework import serializers

from server.messaging.models import Message


class MessageSerializer(serializers.ModelSerializer):
    chat_id = serializers.UUIDField(source="chat.id", required=True)
    chat_name = serializers.CharField(source="chat.name", required=True)
    author_id = serializers.IntegerField(source="author.id", required=True)
    author_username = serializers.CharField(source="author.username", required=True)

    class Meta:
        model = Message
        fields = [
            "id",
            "chat_id",
            "chat_name",
            "author_id",
            "author_username",
            "content",
            "sent_on",
            "delivered_on",
            "created",
            "updated",
        ]
