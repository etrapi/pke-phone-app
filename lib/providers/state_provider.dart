import 'package:flutter/cupertino.dart';
import 'package:hispanosuizaapp/models/state_demo.dart';

class StateProvider extends ChangeNotifier {

  // https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple
  StateDemo state = StateDemo();


  void incrementCount ()  {
      state.incrementCount();
      notifyListeners();
  }

}