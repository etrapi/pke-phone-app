import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
   LocalStorageService _instance;
   SharedPreferences _preferences;
   Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }
}