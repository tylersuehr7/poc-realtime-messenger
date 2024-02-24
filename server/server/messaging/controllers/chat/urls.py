from django.urls import path

from server.messaging.controllers.chat.controllers import ListChatsController

urlpatterns = [
    path("chats", ListChatsController.as_view()),
]
