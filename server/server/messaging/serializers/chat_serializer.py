from rest_framework import serializers

from server.messaging.models import Chat


class ChatSerializer(serializers.ModelSerializer):
    owner_id = serializers.IntegerField(source="owner.id", required=True)
    owner_username = serializers.CharField(source="owner.username", required=True)

    class Meta:
        model = Chat
        fields = [
            "id",
            "name",
            "owner_id",
            "owner_username",
            "created",
            "updated",
        ]
