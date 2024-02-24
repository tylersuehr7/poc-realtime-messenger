part of '../chats_screen.dart';

class _ErrorStateWithRetry extends StatelessWidget {
  const _ErrorStateWithRetry();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Failed to load chats, please try again!"),
          IconButton(onPressed: () => context.read<ChatsManager>().initialize(), icon: const Icon(Icons.refresh)),
        ],
      )
    );
  }
}
