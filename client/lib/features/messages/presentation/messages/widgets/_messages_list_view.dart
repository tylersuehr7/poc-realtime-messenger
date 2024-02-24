part of '../messages_screen.dart';

class _MessagesListView extends StatelessWidget {
  final _MessagesInitialized state;

  const _MessagesListView(this.state);

  @override
  Widget build(BuildContext context) {
    if (state.messages.isEmpty) {
      return const Center(child: Text("No messages yet, say hi!"));
    }

    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final Message message = state.messages[state.messages.length - 1 - index];

        final bool isSender = (state.author.id == message.authorId);
        final Color backColor = isSender ? scheme.primary : scheme.primaryContainer;
        final Color textColor = isSender ? scheme.onPrimary : scheme.onPrimaryContainer;

        return BubbleSpecialThree(
          text: message.content,
          sent: true,
          delivered: true,
          seen: true,
          isSender: state.author.id == message.authorId,
          color: backColor,
          textStyle: TextStyle(
            color: textColor,
            fontSize: 12.0,
          ),
        );
      },
    );
  }
}
