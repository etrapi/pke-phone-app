/*import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hispanosuizaapp/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageProvider extends ChangeNotifier {

  static const String UserKey = 'user';
  bool demoMode = true;
  final defaultUser = User (name:"Saul", surname:"Trapiello", keyId: 1, demoMode: true);
  var instance;

  setup() async {
    instance = await SharedPreferences.getInstance();
  }

  LocalStorageProvider () {
    setup();
  }

  // user
  User get user  {
    var userJson = _getFromDisk(UserKey);
    print (userJson.toString());
    if (userJson == null) {
      return defaultUser;
    }
    return User.fromJson(json.decode(userJson));

  }

  set user(User userToSave) {
    saveStringToDisk(UserKey, json.encode(userToSave.toJson()));
  }




  // Get and Set from Disk
  dynamic _getFromDisk(String key) {
    var prefs = instance;
    print ("prefs" + prefs.toString());
    var value = prefs.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }
  void saveStringToDisk(String key, String content)  {
    var prefs = instance;
    prefs.setString(UserKey, content);
    print('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    notifyListeners();
  }
}*/