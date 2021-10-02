
import 'package:hispanosuizaapp/core/services/auth_factory.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MailAuthenticationService implements AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> handleSignIn(String _user, String _password) async {
    final User user =  (await _firebaseAuth.signInWithEmailAndPassword(
        email: _user, password: _password
    )).user;

    if (user == null) {
      print ("user is null");
      return null;
    } else {
      return user;
    }
  }

  @override
  void logout() {
    _firebaseAuth.signOut();
  }
}