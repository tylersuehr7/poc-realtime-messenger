import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/chats/domain/models/participant.dart';
import 'package:client/features/chats/domain/services/chat_service.dart';
import 'package:client/integrations/server_sdk.dart';
import 'package:server_api_client_dart/server_api_client_dart.dart' as server;

class ChatServiceImpl implements IChatService {
  const ChatServiceImpl();

  @override
  Future<List<Participant>> getAllChatParticipants(Chat chat) async {
    final server.ListChatParticipantsResponse response = (await ServerClient.instance.getParticipantApi()
      .listChatParticipants(chatId: chat.id, limit: 200)
    ).data!;
    return response.results.map((e) => Participant(
      id: e.id,
      accountId: e.userId,
      accountUsername: e.userUsername,
      chatId: e.chatId,
      chatName: e.chatName,
      created: e.created,
      updated: e.updated,
    )).toList();
  }

  @override
  Future<List<Chat>> getAllChats() async {
    final server.ListChatsResponse response = (await ServerClient.instance.getChatApi().listChats(limit: 200)).data!;
    return response.results.map((e) => Chat(
      id: e.id,
      name: e.name,
      ownerId: e.ownerId,
      ownerUsername: e.ownerUsername,
      created: e.created,
      updated: e.updated,
    )).toList();
  }
}
