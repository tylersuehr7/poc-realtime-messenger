part of '../messages_screen.dart';

const String _websocketEndpoint = "ws://10.0.0.247:10000";

final class _MessagesScreenController extends Cubit<_MessagesState> {
  final IMessageService _messageService = injector<IMessageService>();
  final LoginManager loginManager;

  WebSocket? webSocket;
  StreamSubscription? webSocketSubscription;

  _MessagesScreenController({
    required this.loginManager,
  }): super(const _MessagesUninitialized());


  @override
  Future<void> close() async {
    await _unsubscribeFromRealTimeEvents();
    return super.close();
  }

  Future<void> initialize(final Chat chat) async {
    if (state is! _MessagesUninitialized && state is! _MessagesFatalError) {
      return;
    }

    emit(const _MessagesInitializing());

    try {
      final ApplicationUser user = (loginManager.state as AppUserLoggedIn).user;

      final List<Message> messages = await _messageService.getAllMessageHistory(chat);

      emit(_MessagesInitialized(author: user, messages: messages));

      await _subscribeToRealTimeEvents(chat);
    } catch(ex) {
      final String reason = (ex is ServerClientError) ? ex.message : "Failed to initialize messages!";
      emit(_MessagesFatalError(reason));
      rethrow;
    }
  }

  Future<void> sendTextMessage(final String content) async {
    dynamic state = this.state;

    if (state is! _MessagesInitialized || state.isSending) {
      return;
    }

    emit((state = state.setIsSending(true)));

    try {
      final Message newMessage = Message(
        id: const Uuid().v4(),
        authorId: state.author.id,
        authorUsername: state.author.username,
        content: content,
        sentOn: DateTime.now(),
        created: DateTime.now(),
        updated: DateTime.now(),
      );

      final Map<String, dynamic> messageEvent = {
        "event_name": "new_message",
        "data": {
          "id": newMessage.id,
          "content": content,
          "sent_on": newMessage.sentOn!.toIso8601String(),
        },
      };

      final String jsonMessageEvent = json.encode(messageEvent);
      webSocket?.add(jsonMessageEvent);

      final List<Message> updatedMessages = state.messages.toList();
      updatedMessages.insert(0, newMessage);

      state = state.setIsSending(false);
      state = state.setMessages(updatedMessages);

      emit(state);
    } catch(ex) {
      // TODO nice error handling or alert system here
      emit((state = state.setIsSending(false)));
      rethrow;
    }
  }

  Future<void> _subscribeToRealTimeEvents(final Chat chat) async {
    final String authHeader = ServerClient.instance.dio.options.headers["Authorization"];

    webSocket = await WebSocket.connect(
      "$_websocketEndpoint/ws/messages/${chat.id}",
      headers: {
        "Authorization": authHeader,
      }
    );

    webSocketSubscription = webSocket!.listen((event) => _onRemoteMessageEvent(event));
  }

  Future<void> _unsubscribeFromRealTimeEvents() async {
    await webSocket?.close();
    await webSocketSubscription?.cancel();
    webSocket = null;
    webSocketSubscription = null;
  }

  Future<void> _onRemoteMessageEvent(String eventAsString) async {
    final dynamic state = this.state;

    if (state is! _MessagesInitialized) {
      return;
    }

    final Map<String, dynamic> event = json.decode(eventAsString);

    final String eventName = event["event_name"];
    final Map<String, dynamic> eventPayload = event["data"];

    if ("new_message" == eventName) {
      final String newMessageId = eventPayload["id"];
      final Message newMessage = await _messageService.getMessage(newMessageId);

      final List<Message> updatedMessages = state.messages.toList();
      updatedMessages.insert(0, newMessage);

      emit(state.setMessages(updatedMessages));
    } else if ("edit_message" == eventName) {
      final String editedMessageId = eventPayload["id"];
      final Message editedMessage = await _messageService.getMessage(editedMessageId);

      final List<Message> updatedMessages = state.messages.toList();
      final int index = updatedMessages.indexWhere((e) => e.id == editedMessageId);

      if (index != -1) {
        updatedMessages.removeAt(index);
        updatedMessages.insert(index, editedMessage);
        emit(state.setMessages(updatedMessages));
      }
    } else if ("delete_message" == eventName) {
      final String deletedMessageId = eventPayload["id"];

      final List<Message> updatedMessages = state.messages.toList();
      updatedMessages.removeWhere((e) => e.id == deletedMessageId);

      emit(state.setMessages(updatedMessages));
    }
  }
}

sealed class _MessagesState extends Equatable {
  const _MessagesState();

  @override
  List<Object?> get props => [];
}

final class _MessagesUninitialized extends _MessagesState {
  const _MessagesUninitialized();
}

final class _MessagesInitializing extends _MessagesState {
  const _MessagesInitializing();
}

final class _MessagesFatalError extends _MessagesState {
  final String reason;

  const _MessagesFatalError(this.reason);

  @override
  List<Object> get props => [reason];
}

final class _MessagesInitialized extends _MessagesState {
  final ApplicationUser author;
  final List<Message> messages;
  final bool isSending;

  const _MessagesInitialized({
    required this.author,
    required this.messages,
    this.isSending = false,
  });

  @override
  List<Object> get props => [
    author,
    messages,
    isSending,
  ];

  _MessagesInitialized setMessages(final List<Message> messages) {
    return _MessagesInitialized(
      author: author,
      messages: messages,
      isSending: isSending,
    );
  }

  _MessagesInitialized setIsSending(final bool isSending) {
    return _MessagesInitialized(
      author: author,
      messages: messages,
      isSending: isSending,
    );
  }
}
