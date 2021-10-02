import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hispanosuizaapp/core/services/auth_factory.dart';
import 'package:hispanosuizaapp/providers/login_provider.dart';
import '../../app_localizations.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  String _password = '';

  String _errorMessage = '';

  String setError(String code) {
    print("Code: " + code);
    //TODO: Add all texts to localizations
    switch (code) {
      case "":
        _errorMessage = code;
        break;
      case "ERROR_INVALID_EMAIL":
        _errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        _errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        _errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        _errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        _errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        _errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        _errorMessage = "An undefined Error happened.";
    }
    return _errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/mipmap/mipmap-hdpi/ic_hispano_suiza.png',
                  scale: 3,
                ),
                Container(
                  width: 280.0,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          onSaved: (value) => _email = value.trim(),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: localizations.t('login.email'),
                            hintStyle:
                                TextStyle(fontFamily: 'Dinpro', fontSize: 18),
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return localizations.t('login.emailblank');
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onSaved: (value) => _password = value.trim(),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: localizations.t('login.pass'),
                            hintStyle:
                                TextStyle(fontFamily: 'Dinpro', fontSize: 18),
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return localizations.t('login.passblank');
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Consumer<LoginProvider>(builder: (BuildContext context,
                            LoginProvider login, Widget child) {
                          // if (value.isLoading()) {
                          //   return CircularProgressIndicator();
                          // } else {
                          return Column(children: [
                            Text(
                              setError(login.getError()),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Dinpro',
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 55,
                            ),
                            OutlineButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                child: Text(
                                  localizations.t('login.login'),
                                  style: TextStyle(
                                      fontFamily: 'Dinpro', fontSize: 20),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    login.login(
                                        AuthService.EMAIL, _email, _password);
                                  }
                                }),
                          ]);
                        }),
                      ],
                    ),
                  ),
                ),
                Text(
                  localizations.t('login.forgot'),
                  style: TextStyle(fontFamily: 'Dinpro', fontSize: 18),
                ),
              ],
            ),
          ),
        ));
    throw UnimplementedError();
  }
}
