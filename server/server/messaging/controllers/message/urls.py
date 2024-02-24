from django.urls import path

from server.messaging.controllers.message.controllers import ListChatMessagesController, GetChatMessageController

urlpatterns = [
    path("chats/<uuid:chat_id>/messages", ListChatMessagesController.as_view()),
    path("messages/<uuid:message_id>", GetChatMessageController.as_view()),
]
