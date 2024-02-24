from rest_framework import serializers

from server.messaging.models import Participant


class ChatParticipantSerializer(serializers.ModelSerializer):
    chat_id = serializers.UUIDField(source="chat.id", required=True)
    chat_name = serializers.CharField(source="chat.name", required=True)
    user_id = serializers.IntegerField(source="user.id", required=True)
    user_username = serializers.CharField(source="user.username", required=True)

    class Meta:
        model = Participant
        fields = [
            "id",
            "chat_id",
            "chat_name",
            "user_id",
            "user_username",
            "created",
            "updated",
        ]
