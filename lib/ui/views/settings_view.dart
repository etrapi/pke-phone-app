import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_localizations.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _email = "";
  List<bool> _units = [true, false]; //Km, Miles

  _getUnits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _units[0] = (prefs.getBool('units') ?? true);
      _units[1] = (!prefs.getBool('units') ?? false);
    });
  }
  _setUnits(bool units) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("units", units);
  }


  @override
  void initState() {
    _getUnits();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    var login = Provider.of<LoginProvider>(context);
    login.loginState();
    setState(() {
      if (login.currentUser()!=null)
        _email = login.currentUser().email.toString();
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
                padding: EdgeInsets.all(10.0),
                child:
                    IconButton(
                          icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                      )
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top:5.0,bottom:15),
                child: Text (
                  localizations.t('settings.units') ,
                  style: TextStyle(
                      fontFamily: 'Dinpro',
                      fontSize: 18),
                ),
              ),
              ToggleButtons (
                children: [
                  Text(
                    "       "+localizations.t('settings.km') + "       ",
                    style: TextStyle(
                        fontFamily: 'Dinpro',
                        fontSize: 16),
                  ),
                  Text(
                    "     "+ localizations.t('settings.miles') +"     ",
                    style: TextStyle(
                        fontFamily: 'Dinpro',
                        fontSize: 16),
                  ),

                ],
                borderRadius: BorderRadius.circular(20),
                borderWidth: 1,
                borderColor: Colors.grey,
                selectedBorderColor: Colors.grey,
                isSelected: _units,
                color: Colors.white,
                selectedColor: Colors.tealAccent,
                onPressed:  (int index) {
                  setState(() {
                    _units[0] = !_units[0];
                    _units[1] = !_units[1];
                  });
                  _setUnits(_units[0]);
                },
              ),
              SizedBox(height: 28),
              Text (
                _email,
                style: TextStyle(
                    fontFamily: 'Dinpro',
                    fontSize: 18),
              ),
              SizedBox(height: 10),
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
