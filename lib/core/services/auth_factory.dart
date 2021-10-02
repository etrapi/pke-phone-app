import 'package:hispanosuizaapp/core/services/auth_mail.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthService {
  EMAIL,
  GOOGLE,
  TWITTER,
  FACEBOOK,
}

class AuthenticationServiceFactory {
  const AuthenticationServiceFactory();

  AuthenticationService createAuthService(AuthService authService) {
    switch (authService) {
      case AuthService.EMAIL:
        return MailAuthenticationService();
      case AuthService.GOOGLE:
        //return GoogleAuthenticationProvider();
        break;
      case AuthService.TWITTER:
      // TODO: Handle this case.
        break;
      case AuthService.FACEBOOK:
      // TODO: Handle this case.
        break;
    }
    return null;
  }
}

abstract class AuthenticationService {
  Future<User> handleSignIn(String user, String password);
  void logout();
}
