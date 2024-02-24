import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:client/features/authentication/authentication.dart';
import 'package:client/features/authentication/domain/models/application_user.dart';
import 'package:client/features/chats/blocs/chats_manager.dart';
import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/messages/domain/models/message.dart';
import 'package:client/features/messages/domain/services/message_service.dart';
import 'package:client/injector.dart';
import 'package:client/integrations/server_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'controllers/_messages_screen_controller.dart';
part 'widgets/_error_state_with_retry.dart';
part 'widgets/_message_composer.dart';
part 'widgets/_messages_list_view.dart';

class MessagesScreen extends StatelessWidget {
  static final String screenName = (MessagesScreen).toString();

  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Chat chat = _resolveChat(context);
    return BlocProvider<_MessagesScreenController>(
      create: (context) => _MessagesScreenController(
        loginManager: context.read<LoginManager>(),
      )..initialize(chat),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Messages in ${chat.name}"),
        ),
        body: BlocBuilder<_MessagesScreenController, _MessagesState>(
          builder: (context, state) {
            switch (state) {
              case _MessagesUninitialized():
              case _MessagesInitializing():
                return const Center(child: CircularProgressIndicator());
              case _MessagesFatalError():
                return _ErrorStateWithRetry(chat: chat);
              case _MessagesInitialized():
                return Column(
                  children: [
                    Expanded(child: _MessagesListView(state)),
                    const _MessageComposer(),
                  ],
                );
            }
          },
        ),
      )
    );
  }

  static Chat _resolveChat(final BuildContext context) {
    final String chatId = _resolveChatId(context);
    final ChatsManager chatsManager = context.read<ChatsManager>();
    final dynamic chatsState = chatsManager.state;

    if (chatsState is! ChatsInitialized) {
      throw StateError("Chats must be initialized at this point!");
    }

    return chatsState.chats.firstWhere((e) => e.id == chatId);
  }

  static String _resolveChatId(final BuildContext context) {
    final GoRouterState route = GoRouterState.of(context);
    final String? chatId = route.pathParameters["chatId"];
    if (chatId == null) {
      throw StateError("MessagesScreen must have a :chatId path parameter!");
    }
    return chatId;
  }
}
