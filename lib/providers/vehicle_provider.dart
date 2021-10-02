import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  Vehicle vehicle = Vehicle.fromMap(
      {'NDoorDriverStatus': 1,
        'NDoorPaxStatus': 0,
        'NLowBeamHeadStatus' : 0,
        'NWarningLightStatus' : 0,
        'NBootStatus' : 0,
        'NBonnetStatus' : 0,
        'NChargerCapStatus' : 0,
        'BCharging' : true,
        'rSoC' : 82.0,
        'sRange' : 320
      });

  void cmdDriverDoor() async {
    if (vehicle.NDoorDriverStatus == 1) {
        vehicle.NDoorDriverStatus = 2;
    } else if (vehicle.NDoorDriverStatus == 2) {
      vehicle.NDoorDriverStatus = 1;
    }
    notifyListeners();
  }

  void cmdPaxDoor() async {
    if (vehicle.NDoorPaxStatus == 1) {
      vehicle.NDoorPaxStatus = 2;
    } else if (vehicle.NDoorPaxStatus == 2) {
      vehicle.NDoorPaxStatus = 1;
    }
    notifyListeners();
  }
}