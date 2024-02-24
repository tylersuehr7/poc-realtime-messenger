import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/chats/domain/models/participant.dart';

abstract interface class IChatService {
  Future<List<Chat>> getAllChats();
  Future<List<Participant>> getAllChatParticipants(Chat chat);
}
