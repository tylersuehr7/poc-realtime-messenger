from django.urls import path, include

from server.messaging.controllers.chat import urls as chat_urls
from server.messaging.controllers.message import urls as message_urls
from server.messaging.controllers.participant import urls as participant_urls

urlpatterns = [
    path("", include(chat_urls)),
    path("", include(message_urls)),
    path("", include(participant_urls)),
]
