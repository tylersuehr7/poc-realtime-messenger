from django.urls import re_path

from server.messaging.consumers.messaging.messaging_consumer import MessagingConsumer

urlpatterns = [
    # re_path(r"ws/chats/(?P<chat_id>\w+)/$", ChatMessagesConsumer.as_asgi()),
    re_path(r"ws/messages/(?P<chat_id>[0-9a-f-]+)", MessagingConsumer.as_asgi()),
]
