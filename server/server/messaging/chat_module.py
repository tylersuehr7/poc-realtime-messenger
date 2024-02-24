from injector import Module, singleton, provider

from server.messaging.services.chat.chat_service import IChatService
from server.messaging.services.chat.chat_service_impl import ChatServiceImpl
from server.messaging.services.message.message_service import IMessageService
from server.messaging.services.message.message_service_impl import MessageServiceImpl
from server.messaging.services.participant.participant_service import IParticipantService
from server.messaging.services.participant.participant_service_impl import ParticipantServiceImpl


class ChatModule(Module):
    @provider
    @singleton
    def chat_service(self) -> IChatService:
        return ChatServiceImpl()

    @provider
    @singleton
    def participant_service(self) -> IParticipantService:
        return ParticipantServiceImpl()

    @provider
    @singleton
    def message_service(self) -> IMessageService:
        return MessageServiceImpl()
