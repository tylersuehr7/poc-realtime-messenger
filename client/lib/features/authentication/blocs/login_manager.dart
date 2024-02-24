import 'package:client/features/authentication/domain/models/application_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginManager extends Cubit<LoginState> {
  LoginManager(): super(const AppUserLoggedOut());

  void setApplicationUser(final ApplicationUser user) {
    emit(AppUserLoggedIn(user));
  }

  void setLoggedOut() {
    emit(const AppUserLoggedOut());
  }
}

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

final class AppUserLoggedOut extends LoginState {
  const AppUserLoggedOut();
}

final class AppUserLoggedIn extends LoginState {
  final ApplicationUser user;

  const AppUserLoggedIn(this.user);

  @override
  List<Object> get props => [user];
}
