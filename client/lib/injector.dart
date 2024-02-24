import 'package:client/features/authentication/domain/services/authentication_service.dart';
import 'package:client/features/authentication/domain/services/authentication_service_impl.dart';
import 'package:client/features/chats/domain/services/chat_service.dart';
import 'package:client/features/chats/domain/services/chat_service_impl.dart';
import 'package:client/features/messages/domain/services/message_service.dart';
import 'package:client/features/messages/domain/services/message_service_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt injector = GetIt.instance;

/// Initializes all application dependencies.
void initializeDependencies() {
  injector.registerSingleton<IAuthenticationService>(const AuthenticationServiceImpl());
  injector.registerSingleton<IChatService>(const ChatServiceImpl());
  injector.registerSingleton<IMessageService>(const MessageServiceImpl());
}
