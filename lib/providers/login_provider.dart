import 'package:flutter/services.dart';
import 'package:hispanosuizaapp/core/services/auth_factory.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginProvider with ChangeNotifier {
  AuthenticationService _authenticationService;
  AuthenticationServiceFactory _authenticationProviderFactory;

  bool _loggedIn = false;
  bool _loading = true;
  bool _error = false;
  String _errorStr = '';

  User user;

  LoginProvider({
    @required FirebaseAuth firebaseAuth,
    AuthenticationServiceFactory authenticationProviderFactory = const AuthenticationServiceFactory(),
  }) {
    _authenticationProviderFactory = authenticationProviderFactory;
    setup();
    loginState();
  }
  setup () async  {
     user =  FirebaseAuth.instance.currentUser;
     //print ("user: " + _user.uid);
  }

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  bool isError() => _error;

  String getError () => _errorStr;

 User currentUser() => user;


  Future<void> login(AuthService authService, String _user, String _password) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _authenticationService =
          _authenticationProviderFactory.createAuthService(authService);
      _loading = true;
      user = await _authenticationService.handleSignIn(_user, _password);
      print("User: " );
      if (_user != null) {
        _loading = false;
        _loggedIn = true;
        _error = false;
        _prefs.setBool('isLoggedIn', _loggedIn);
        _prefs.setString('uid', user.uid);
      } else {
        _error = true;
        _errorStr = 'Logging error';
      }
      notifyListeners();
    }  on FirebaseAuthException catch (e) {
      _error = true;
      _errorStr = e.code;
      notifyListeners();

    } catch (e) {
      print("Error: " + e.toString());

      notifyListeners();
    }
  }

  void logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    if (_authenticationService != null) {
      _authenticationService.logout();
      _authenticationService = null;
    }
    _loggedIn = false;
    notifyListeners();
  }

  void loginState() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      _loggedIn = user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }
}
