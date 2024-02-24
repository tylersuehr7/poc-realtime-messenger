import 'package:client/features/authentication/domain/models/application_user.dart';

abstract interface class IAuthenticationService {
  Future<ApplicationUser> authenticate(String username, String password);
  Future<void> deauthenticate();
}
