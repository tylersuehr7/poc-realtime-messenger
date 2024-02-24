import 'package:client/features/chats/blocs/chats_manager.dart';
import 'package:client/features/chats/domain/models/chat.dart';
import 'package:client/features/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'widgets/_chat_list_item.dart';
part 'widgets/_chat_list_view.dart';
part 'widgets/_error_state_with_retry.dart';

class ChatsScreen extends StatelessWidget {
  static final String screenName = (ChatsScreen).toString();

  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatsManager>().initialize();
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Chats"),
      ),
      body: BlocBuilder<ChatsManager, ChatsState>(
        builder: (context, state) {
          switch (state) {
            case ChatsUninitialized():
            case ChatsInitializing():
              return const Center(child: CircularProgressIndicator());
            case ChatsFatalError():
              return const _ErrorStateWithRetry();
            case ChatsInitialized():
              return _ChatsListView(state);
          }
        },
      ),
    );
  }
}
