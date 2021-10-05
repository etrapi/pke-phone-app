import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/core/models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  Vehicle vehicle = Vehicle.fromMap(
      {'NDoorDriverStatus': 0,
        'NDoorPaxStatus': 0,
        'NLowBeamHeadStatus' : 1,
        'NWarningLightStatus' : 0,
        'NBootStatus' : 0,
        'NBonnetStatus' : 0,
        'NChargerCapStatus' : 0,
        'BCharging' : true,
        'rSoC' : 82.0,
        'sRange' : 320
      });
}