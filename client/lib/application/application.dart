import 'package:client/features/authentication/authentication.dart';
import 'package:client/features/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routing/router.dart';

final class ClientApplication extends StatelessWidget {
  const ClientApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginManager>(
          create: (_) => LoginManager(),
        ),
        BlocProvider<ChatsManager>(
          create: (_) => ChatsManager(),
        ),
      ],
      child: MaterialApp.router(
        title: "Messaging PoC",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        routerConfig: router,
        builder: (final BuildContext context, final Widget? child) => BlocListener<LoginManager, LoginState>(
          listener: _onHandleLoginStateChanged,
          child: child!,
        ),
      ),
    );
  }

  /// Perform the appropriate routing when authentication state is changed.
  ///
  /// [context] the active build context
  /// [state] the current login state
  static void _onHandleLoginStateChanged(final BuildContext context, final LoginState state) {
    if (state is AppUserLoggedOut) {
      router.goNamed(AuthenticationScreen.screenName);
    } else if (state is AppUserLoggedIn) {
      router.goNamed(ChatsScreen.screenName);
    }
  }
}
