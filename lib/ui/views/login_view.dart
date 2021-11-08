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



  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    String setError(String code) {
        print("Code: " + code);
        switch (code) {
          case "":
            //_errorMessage = localizations.t('login.error');
            break;
          case "invalid-email":
            _errorMessage = localizations.t('errors.ERROR_INVALID_EMAIL');
            break;
          case "wrong-password":
            _errorMessage = localizations.t('errors.ERROR_WRONG_PASSWORD');
            break;
          case "user-not_found":
            _errorMessage = localizations.t('errors.ERROR_USER_NOT_FOUND');
            break;
          case "user-disabled":
            _errorMessage = localizations.t('errors.ERROR_USER_DISABLED');
            break;
          case "too-many-requests":
            _errorMessage = localizations.t('errors.ERROR_TOO_MANY_REQUESTS');
            break;
          case "operation-not-allowed":
            _errorMessage = localizations.t('errors.ERROR_OPERATION_NOT_ALLOWED');
            break;
          default:
            _errorMessage = localizations.t('errors.ERROR_DEFAULT');
        }
      return _errorMessage;
    }


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
                            if (login.isError())
                              Text(
                                setError(login.getError()),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Dinpro',
                                    fontSize: 16),
                              ),
                            SizedBox(
                              height: 55,
                            ),
                            OutlineButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0)),
                                    borderSide:
                                        BorderSide (color: Colors.grey, width: 0.5),
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
                  "",
                  //localizations.t('login.forgot'),
                  style: TextStyle(fontFamily: 'Dinpro', fontSize: 18),
                ),
              ],
            ),
          ),
        ));
    throw UnimplementedError();
  }
}
