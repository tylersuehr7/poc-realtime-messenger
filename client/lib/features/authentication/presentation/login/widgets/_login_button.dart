part of '../authentication_screen.dart';

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final _LoginScreenController controller = context.read<_LoginScreenController>();
    return BlocBuilder<_LoginScreenController, _LoginScreenState>(
      builder: (context, state) => FilledButton(
          onPressed: state.isSubmitButtonDisabled ? null : () => controller.performLogin(),
          child: Visibility(
            visible: !state.isLoading,
            replacement: const CircularProgressIndicator(),
            child: const Text("Login"),
          )
      ),
    );
  }
}
