import 'package:client/features/authentication/domain/exceptions/invalid_login_exception.dart';
import 'package:client/features/authentication/domain/models/application_user.dart';
import 'package:client/features/authentication/domain/services/authentication_service.dart';
import 'package:client/integrations/server_sdk.dart';
import 'package:server_api_client_dart/server_api_client_dart.dart';

class AuthenticationServiceImpl implements IAuthenticationService {
  const AuthenticationServiceImpl();

  @override
  Future<ApplicationUser> authenticate(String username, String password) async {
    // Perform the authentication with the server client
    final AuthenticateIdentityResponse response;
    try {
      response = (await ServerClient.instance.getIdentityApi().authenticate(
          authenticateIdentityRequest: (AuthenticateIdentityRequestBuilder()
            ..username = username
            ..password = password
          ).build()
      )).data!;
    } on ServerClientError catch(ex) {
      throw InvalidLoginException(ex.message);
    }

    ServerClient.instance.setAccessToken(response.access);

    return ApplicationUser(
      id: response.account.pk,
      username: response.account.username,
      created: response.account.dateJoined ?? DateTime.now(),
      updated: response.account.lastLogin ?? DateTime.now(),
    );
  }

  @override
  Future<void> deauthenticate() async {
    ServerClient.instance.clearAccessToken();
  }
}
