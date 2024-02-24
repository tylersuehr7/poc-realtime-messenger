part of '../authentication_screen.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_LoginScreenController, _LoginScreenState>(
        builder: (context, state) => Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ListBody(
                children: [

                  if (state.error != null)
                    _ErrorBanner(state.error!),

                  TextFormField(
                    initialValue: state.username,
                    onChanged: context.read<_LoginScreenController>().setUsername,
                    decoration: const InputDecoration(
                      hintText: "Username",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !state.isLoading,
                  ),

                  const SizedBox(height: 10.0),

                  TextFormField(
                    initialValue: state.password,
                    onChanged: context.read<_LoginScreenController>().setPassword,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    obscureText: true,
                    enabled: !state.isLoading,
                  ),

                ],
              ),
            )
        )
    );
  }
}
