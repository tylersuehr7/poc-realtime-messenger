import 'package:client/features/authentication/authentication.dart';
import 'package:client/features/authentication/domain/exceptions/invalid_login_exception.dart';
import 'package:client/features/authentication/domain/models/application_user.dart';
import 'package:client/features/authentication/domain/services/authentication_service.dart';
import 'package:client/injector.dart';
import 'package:client/utils/optional.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'controllers/login_screen_controller.dart';
part 'widgets/_error_banner.dart';
part 'widgets/_login_button.dart';
part 'widgets/_login_form.dart';

class AuthenticationScreen extends StatelessWidget {
  static final String screenName = (AuthenticationScreen).toString();

  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_LoginScreenController>(
      create: (final BuildContext context) => _LoginScreenController(
        loginManager: context.read<LoginManager>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Authentication"),
        ),
        floatingActionButton: const _LoginButton(),
        body: const SingleChildScrollView(child: _LoginForm()),
      )
    );
  }
}
