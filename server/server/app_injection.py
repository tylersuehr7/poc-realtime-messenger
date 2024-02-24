from injector import Injector

from server.authentication.authentication_module import AuthenticationModule
from server.messaging.chat_module import ChatModule

injection = Injector([
    AuthenticationModule(),
    ChatModule(),
])
