import 'package:client/features/authentication/domain/models/application_user.dart';
import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/messages/domain/models/message.dart';

final class Messenger {
  final Chat chat;
  final ApplicationUser author;

  Messenger({
    required this.chat,
    required this.author,
  });

  Future<void> subscribe() async {
    throw UnimplementedError();
  }

  Future<void> unsubscribe() async {
    throw UnimplementedError();
  }

  Future<List<Message>> getMessageHistory() async {
    throw UnimplementedError();
  }

  Future<void> sendText(final String content) async {
    throw UnimplementedError();
  }

  Future<void> editMessage(final Message message, final String content) async {
    throw UnimplementedError();
  }

  Future<void> deleteMessage(final Message message) async {
    throw UnimplementedError();
  }
}

abstract interface class LocalMessageEvents {
  Future<void> onMessageSending(Message message);
  Future<void> onMessageSendingFailure(Message message, String reason);
  Future<void> onMessageSent(Message message);
}

abstract interface class RemoteMessageEvents {
  Future<void> onMessageReceived(Message message);
  Future<void> onMessageUpdated(Message message);
  Future<void> onMessageDeleted(Message message);
}
