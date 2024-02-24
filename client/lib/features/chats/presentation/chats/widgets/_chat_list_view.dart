part of '../chats_screen.dart';

class _ChatsListView extends StatelessWidget {
  final ChatsInitialized state;

  const _ChatsListView(this.state);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ChatsManager>().refresh(),
      child: ListView.builder(
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.chats.length,
        itemBuilder: (context, index) {
          final Chat chat = state.chats[index];
          return _ChatListItem(chat: chat, onTap: () => context.goNamed(MessagesScreen.screenName, pathParameters: {
            "chatId": chat.id,
          }));
        },
      ),
    );
  }
}
