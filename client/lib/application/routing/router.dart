import 'package:client/features/authentication/authentication.dart';
import 'package:client/features/chats/chats.dart';
import 'package:client/features/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'transitions.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/",
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: AuthenticationScreen.screenName,
      path: "/",
      pageBuilder: (final BuildContext context, final GoRouterState state) => NoAnimationPage(
        state: state,
        child: const AuthenticationScreen(),
      ),
    ),
    GoRoute(
      name: ChatsScreen.screenName,
      path: "/chats",
      pageBuilder: (final BuildContext context, final GoRouterState state) => FadeInTransitionPage(
        state: state,
        child: const ChatsScreen(),
      ),
      routes: [
        GoRoute(
          name: MessagesScreen.screenName,
          path: ":chatId",
          pageBuilder: (final BuildContext context, final GoRouterState state) => FadeInTransitionPage(
            state: state,
            child: const MessagesScreen(),
          ),
        ),
      ]
    ),
  ],
  redirect: (final BuildContext context, final GoRouterState state) {
    final LoginManager loginManager = context.read<LoginManager>();
    if ("/" != state.path && loginManager.state is! AppUserLoggedIn) {
      return "/";
    }
    return null;
  },
);
