part of '../messages_screen.dart';

class _ErrorStateWithRetry extends StatelessWidget {
  final Chat chat;

  const _ErrorStateWithRetry({
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Failed to load messages, please try again!"),
          IconButton(onPressed: () => context.read<_MessagesScreenController>().initialize(chat), icon: const Icon(Icons.refresh)),
        ],
      )
    );
  }
}
