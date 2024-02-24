from django.urls import path

from server.messaging.controllers.participant.controllers import ListChatParticipantsController

urlpatterns = [
    path("chats/<uuid:chat_id>/participants", ListChatParticipantsController.as_view()),
]
