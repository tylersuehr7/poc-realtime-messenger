part of '../authentication_screen.dart';

final class _LoginScreenController extends Cubit<_LoginScreenState> {
  final IAuthenticationService _authService = injector<IAuthenticationService>();
  final LoginManager loginManager;

  _LoginScreenController({
    required this.loginManager,
  }): super(const _LoginScreenState());

  void setUsername(final String username) {
    emit(state.copyWith(username: username));
  }

  void setPassword(final String password) {
    emit(state.copyWith(password: password));
  }

  void setError(final String? error) {
    emit(state.copyWith(error: Optional.of(error)));
  }

  Future<void> performLogin() async {
    _LoginScreenState state = this.state;

    if (state.isLoading) {
      return;
    }

    emit((state = state.copyWith(
      isLoading: true,
      error: Optional.of(null),
    )));

    try {
      final ApplicationUser user = await _authService.authenticate(state.username, state.password);
      emit((state = state.copyWith(isLoading: false)));
      loginManager.setApplicationUser(user);
    } catch(ex, stackTrace) {
      final String reason = (ex is InvalidLoginException) ? ex.reason : "Failed to perform login!";
      emit((state = state.copyWith(
        isLoading: false,
        error: Optional.of(reason),
      )));
    }
  }
}

final class _LoginScreenState extends Equatable {
  final String username;
  final String password;
  final bool isLoading;
  final String? error;

  const _LoginScreenState({
    this.username = "",
    this.password = "",
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
    username,
    password,
    isLoading,
    error,
  ];

  _LoginScreenState copyWith({
    final String? username,
    final String? password,
    final bool? isLoading,
    final Optional<String?> error = const Optional.nil(),
  }) {
    return _LoginScreenState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error.or(this.error),
    );
  }

  bool get isSubmitButtonDisabled {
    return username.trim().isEmpty || password.trim().isEmpty || isLoading;
  }
}
