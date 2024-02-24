import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/messages/domain/models/message.dart';

abstract interface class IMessageService {
  Future<List<Message>> getAllMessageHistory(Chat chat);
  Future<Message> getMessage(String messageId);
}
