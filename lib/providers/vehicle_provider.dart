import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/core/models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  Vehicle vehicle = Vehicle.fromMap(
      {'NDoorDriverStatus': 0,
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
        vehicle.NDoorDriverStatus = 0;
    } else if (vehicle.NDoorDriverStatus == 0) {
      vehicle.NDoorDriverStatus = 1;
    }
    notifyListeners();
  }

  void cmdPaxDoor() async {
    if (vehicle.NDoorPaxStatus == 1) {
      vehicle.NDoorPaxStatus = 0;
    } else if (vehicle.NDoorPaxStatus == 0) {
      vehicle.NDoorPaxStatus = 1;
    }
    notifyListeners();
  }

  void cmdBonnet() async {
    if (vehicle.NBonnetStatus == 1) {
      vehicle.NBonnetStatus = 0;
    } else if (vehicle.NBonnetStatus == 0) {
      vehicle.NBonnetStatus = 1;
    }
    notifyListeners();
  }

  void cmdBoot() async {
    if (vehicle.NBootStatus == 1) {
      vehicle.NBootStatus = 0;
    } else if (vehicle.NBootStatus == 0) {
      vehicle.NBootStatus = 1;
    }
    notifyListeners();
  }

  void cmdInlet() async {
    if (vehicle.NChargerCapStatus == 1) {
      vehicle.NChargerCapStatus = 0;
    } else if (vehicle.NChargerCapStatus == 0) {
      vehicle.NChargerCapStatus = 1;
    }
    notifyListeners();
  }
}