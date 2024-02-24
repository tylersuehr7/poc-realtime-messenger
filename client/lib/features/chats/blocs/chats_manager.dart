import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/chats/domain/services/chat_service.dart';
import 'package:client/injector.dart';
import 'package:client/integrations/server_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ChatsManager extends Cubit<ChatsState> {
  final IChatService _chatService = injector<IChatService>();

  ChatsManager(): super(const ChatsUninitialized());

  Future<void> initialize() async {
    if (state is! ChatsUninitialized && state is! ChatsFatalError) {
      return;
    }

    emit(const ChatsInitializing());

    try {
      final List<Chat> chats = await _chatService.getAllChats();
      emit(ChatsInitialized(chats: chats));
    } catch(ex) {
      final String reason = (ex is ServerClientError) ? ex.message : "Failed to initialize chats!";
      emit(ChatsFatalError(reason));
      rethrow;
    }
  }

  Future<void> refresh() async {
    dynamic state = this.state;

    if (state is! ChatsInitialized || state.isLoading) {
      return;
    }

    emit((state = ChatsInitialized(chats: state.chats, isLoading: true)));

    try {
      final List<Chat> chats = await _chatService.getAllChats();
      emit(ChatsInitialized(chats: chats, isLoading: false));
    } catch(ex) {
      final String reason = (ex is ServerClientError) ? ex.message : "Failed to refresh chats!";
      // TODO show alert or something
      emit(ChatsInitialized(chats: state.chats, isLoading: false));
      rethrow;
    }
  }
}

sealed class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object?> get props => [];
}

final class ChatsUninitialized extends ChatsState {
  const ChatsUninitialized();
}

final class ChatsInitializing extends ChatsState {
  const ChatsInitializing();
}

final class ChatsFatalError extends ChatsState {
  final String reason;

  const ChatsFatalError(this.reason);

  @override
  List<Object> get props => [reason];
}

final class ChatsInitialized extends ChatsState {
  final List<Chat> chats;
  final bool isLoading;

  const ChatsInitialized({
    required this.chats,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [
    chats,
    isLoading,
  ];
}
