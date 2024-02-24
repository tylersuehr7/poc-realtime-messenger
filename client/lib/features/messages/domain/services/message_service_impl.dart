import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/messages/domain/models/message.dart';
import 'package:client/features/messages/domain/services/message_service.dart';
import 'package:client/integrations/server_sdk.dart';
import 'package:server_api_client_dart/server_api_client_dart.dart' as server;

class MessageServiceImpl implements IMessageService {
  const MessageServiceImpl();

  @override
  Future<List<Message>> getAllMessageHistory(Chat chat) async {
    final server.ListChatMessagesResponse response = (await ServerClient.instance.getMessageApi()
      .listChatMessages(chatId: chat.id, limit: 1000)
    ).data!;
    return response.results.map((e) => Message(
      id: e.id,
      authorId: e.authorId,
      authorUsername: e.authorUsername,
      content: e.content,
      sentOn: e.sentOn,
      deliveredOn: e.deliveredOn,
      created: e.created,
      updated: e.updated,
    )).toList();
  }

  @override
  Future<Message> getMessage(String messageId) async {
    final server.GetChatMessageResponse response = (await ServerClient.instance.getMessageApi()
      .getChatMessage(messageId: messageId)
    ).data!;
    return Message(
      id: response.message.id,
      authorId: response.message.authorId,
      authorUsername: response.message.authorUsername,
      content: response.message.content,
      created: response.message.created,
      updated: response.message.updated,
      sentOn: response.message.sentOn,
      deliveredOn: response.message.deliveredOn,
    );
  }
}
