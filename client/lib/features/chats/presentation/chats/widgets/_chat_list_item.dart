part of '../chats_screen.dart';

class _ChatListItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chat.name),
      subtitle: Text("Owner: ${chat.ownerUsername}"),
      leading: CircleAvatar(child: Text(chat.name.characters.first.toUpperCase())),
      onTap: onTap,
    );
  }
}
