import json
import logging
from typing import Optional, List, AnyStr

from asgiref.sync import async_to_sync
from channels.auth import login
from channels.generic.websocket import WebsocketConsumer
from django.contrib.auth.models import User
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.tokens import AccessToken

from server.app_injection import injection
from server.messaging.models import Chat
from server.messaging.services.message.message_service import IMessageService
from server.messaging.services.message.params.process_message_event_params import ProcessMessageEventParams
from server.messaging.services.message.types import MessageEventPayload

logger = logging.getLogger(__name__)

_message_service: IMessageService = injection.get(IMessageService)


class MessagingConsumer(WebsocketConsumer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.chat_id: Optional[str] = None
        self.chat_group_name: Optional[str] = None

    def connect(self):
        # Determine the chat in which this user is connecting to
        self.chat_id = self.scope["url_route"]["kwargs"]["chat_id"]
        self.chat_group_name = f"chat_{self.chat_id}"

        # Authenticate the user requesting the websocket connection
        self.authenticate_websocket_connection()

        # Join the channel group for this chat to receive real-time events
        async_to_sync(self.channel_layer.group_add)(self.chat_group_name, self.channel_name)

        self.accept()

    def disconnect(self, code):
        # Leave the channel group for this chat to stop receiving real-time events
        async_to_sync(self.channel_layer.group_discard)(self.chat_group_name, self.channel_name)

        # Cleanup any instance variables
        self.chat_id = None
        self.chat_group_name = None

    def receive(self, text_data=None, bytes_data=None):
        logger.debug("receive called")

        if text_data is None:
            return

        # Serialize the raw text into a JSON dictionary
        text_data_as_json: dict = json.loads(text_data)

        # Build a dictionary for the raw message event
        raw_message_event: dict = {
            "type": "on.handle.message.event",
            "user_id": self.scope["user"].id,
            "payload": text_data_as_json,
        }

        # Publish the event to the channel group of this chat
        async_to_sync(self.channel_layer.group_send)(self.chat_group_name, raw_message_event)

    def authenticate_websocket_connection(self):
        # Is the user already authenticated in the session?
        existing_user = self.scope.get("user")
        if existing_user and isinstance(existing_user, User):
            return existing_user

        # Look for the "Authorization" header in the connection request
        authorization: Optional[str] = None
        for (key, value) in self.scope["headers"]:
            if b'authorization' == key:
                authorization = value.decode("utf-8")

        if not authorization:
            raise PermissionError("No access token was supplied!")

        authorization: List[AnyStr] = authorization.split("Bearer ")
        if len(authorization) != 2:
            raise PermissionError("Given access token was malformed!")

        # Attempt to construct and verify Access Token from Authorization header value
        try:
            access_token = AccessToken(token=authorization[1], verify=True)
            user = User.objects.get(pk=access_token["user_id"])
        except User.DoesNotExist as e:
            raise PermissionError("No such user for given access token exists!") from e
        except TokenError as e:
            raise PermissionError("Given access token was invalid or expired!") from e
        except Exception as e:
            raise PermissionError("Unable to process access token") from e

        async_to_sync(login)(self.scope, user, None)
        self.scope["session"].save()

        return user

    def on_handle_message_event(self, event: dict):
        logger.debug("on_handle_message_event(…) called")

        event_type: str = event["type"]
        event_user_id: int = event["user_id"]
        event_payload: MessageEventPayload = MessageEventPayload(**event["payload"])

        logger.info(f"Event type: {event_type}")
        logger.info(f"Event user ID: {event_user_id}")
        logger.info(f"Event payload: {event_payload}")

        # Process the event iff the publisher is the current user
        if self.scope["user"].id == event_user_id:
            _message_service.process_message_event(
                ProcessMessageEventParams(
                    payload=event_payload,
                    publisher=self.scope["user"],
                    chat=Chat.objects.get(pk=self.chat_id),
                )
            )
            return

        # Forward the event to other consumer websockets
        text_data: str = json.dumps({
            "event_name": event_payload.event_name,
            "data": event_payload.data,
        })
        self.send(text_data=text_data, close=False)
