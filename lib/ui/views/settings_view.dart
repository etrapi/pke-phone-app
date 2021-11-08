import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String email = "";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    var login = Provider.of<LoginProvider>(context);
    login.loginState();
    setState(() {
      if (login.currentUser()!=null)
        email = login.currentUser().email.toString();
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea (
          child: Column (
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(18.0),
                child:
                    IconButton(
                          icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                      )
              ),
              Text (
                email,
                style: TextStyle(
                    fontFamily: 'Dinpro',
                    fontSize: 18),
              ),
              SizedBox(height: 18),
              OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                        BorderRadius.circular(10.0)),
                      borderSide:
                        BorderSide (color: Colors.grey, width: 0.5),
                  child: Text(
                    localizations.t('settings.signout'),
                    style: TextStyle(
                        fontFamily: 'Dinpro', fontSize: 16),
                  ),
                  onPressed: () {
                    login.logout();
                    Navigator.pop(context);
                  }),
            ],
          )
          ),
        ),
    );
  }
}
