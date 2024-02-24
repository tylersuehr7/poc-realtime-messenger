part of '../messages_screen.dart';

class _MessageComposer extends StatelessWidget {
  const _MessageComposer();

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final FocusNode inputFocus = FocusNode();
    final TextEditingController inputController = TextEditingController();
    return BlocProvider<_MessageComposerController>(
      create: (_) => _MessageComposerController(),
      child: BlocBuilder<_MessageComposerController, _MessageComposerState>(
        builder: (context, composerState) => BlocBuilder<_MessagesScreenController, _MessagesState>(
          builder: (context, messagesState) {

            inputController.text = composerState.input;

            return Form(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                color: scheme.inversePrimary,
                child: TextFormField(
                  focusNode: inputFocus,
                  controller: inputController,
                  onChanged: context.read<_MessageComposerController>().setInput,
                  enabled: messagesState is _MessagesInitialized && !messagesState.isSending,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    hintText: "Type message here…",
                    suffixIcon: IconButton(onPressed: () {
                      context.read<_MessagesScreenController>().sendTextMessage(composerState.input);
                      context.read<_MessageComposerController>().setInput("");
                      inputFocus.unfocus();
                    }, icon: const Icon(Icons.send)),
                  ),
                )
              ),
            );

          },
        )
      )
    );
  }
}

final class _MessageComposerController extends Cubit<_MessageComposerState> {
  _MessageComposerController(): super(const _MessageComposerState());

  void setInput(final String input) {
    emit(_MessageComposerState(input: input));
  }
}

final class _MessageComposerState extends Equatable {
  final String input;

  const _MessageComposerState({
    this.input = "",
  });

  @override
  List<Object?> get props => [
    input,
  ];
}
