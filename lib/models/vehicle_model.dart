

class Vehicle {

  bool BMSFault=false, BChargerPlugged=false, BCharging=false, BDCDCFault=false, BMCUFault=false, BTPMSFault=false;

  num EConsAvg=0, EConsAvgTrip=0, PLimit=0, TBattery=0, TCabin=0, TCabinSetPoint=0, rSoC=0, sRange=0,
      sRangeIncrease=0, sVehicleTotal=0, sVehicleTrip=0, tChargingRemaining=0, vLimit=0;

  num NBonnetStatus=0, NBootStatus=0, NCarSecureStatus=0, NChargerCapStatus=0, NClimateStatus=0, NDefrostStatus=0,
      NDoorDriverStatus=0, NDoorPaxStatus=0, NLowBeamHeadStatus=0, NPLimitEnable=0, NWarningLightStatus=0, NvLimitEnable=0;

  String token='', vehicleId = '', vehicleDescription = '';

  // Default constructor
  Vehicle ({this.token, this.vehicleId, this.vehicleDescription});

  // From Map constructor
  Vehicle.fromMap(Map snapshot) :
        BMSFault = snapshot['BMSFault'] ?? false,
        BChargerPlugged = snapshot['BChargerPlugged'] ?? false,
        BCharging = snapshot['BCharging'] ?? false,
        BDCDCFault = snapshot['BDCDCFault'] ?? false,
        BMCUFault = snapshot['BMCUFault'] ?? false,
        BTPMSFault = snapshot['BTPMSFault'] ?? false,
        EConsAvg = snapshot['EConsAvg'] ?? 0.0,
        EConsAvgTrip = snapshot['EConsAvgTrip'] ?? 0.0,
        PLimit = snapshot['EConsAvgTrip'] ?? 0.0,
        TBattery = snapshot['TBattery'] ?? 0.0,
        TCabin = snapshot['TCabin'] ?? 0.0,
        TCabinSetPoint = snapshot['TCabinSetPoint'] ?? 0.0,
        rSoC  = snapshot['rSoC'] ?? 0.0,
        sRange = snapshot['sRange'] ?? 0.0,
        sRangeIncrease = snapshot['sRangeIncrease'] ?? 0.0,
        sVehicleTotal = snapshot['sVehicleTotal'] ?? 0.0,
        sVehicleTrip = snapshot['sVehicleTrip'] ?? 0.0,
        tChargingRemaining = snapshot['tChargingRemaining'] ?? 0.0,
        vLimit = snapshot['vLimit'] ?? 0.0,
        NBonnetStatus = snapshot['NBonnetStatus'] ?? 0.0,
        NBootStatus = snapshot['NBootStatus'] ?? 0.0,
        NCarSecureStatus = snapshot['NCarSecureStatus'] ?? 0.0,
        NChargerCapStatus = snapshot['NChargerCapStatus'] ?? 0.0,
        NClimateStatus = snapshot['NChargerCapStatus'] ?? 0.0,
        NDefrostStatus = snapshot['NDefrostStatus'] ?? 0.0,
        NDoorDriverStatus = snapshot['NDoorDriverStatus'] ?? 0.0,
        NDoorPaxStatus = snapshot['NDoorPaxStatus'] ?? 0.0,
        NLowBeamHeadStatus = snapshot['NLowBeamHeadStatus'] ?? 0.0,
        NPLimitEnable = snapshot['NPLimitEnable'] ?? 0.0,
        NWarningLightStatus = snapshot['NWarningLightStatus'] ?? 0.0,
        NvLimitEnable = snapshot['NvLimitEnable'] ?? 0.0,
        token = snapshot['token'] ?? '',
        vehicleDescription = snapshot['vehicleDescription'] ?? '';


      toJson() {
          return {
            "BMSFault" : BMSFault,
            "BChargerPlugged" : BChargerPlugged,
            "BCharging" : BCharging,
            "BDCDCFault":BDCDCFault,
            "BMCUFault" : BMCUFault,
            "BTPMSFault" : BTPMSFault,
            "EConsAvg" : EConsAvg,
            "EConsAvgTrip" : EConsAvgTrip,
            "PLimit" : EConsAvgTrip,
            "TBattery" : TBattery,
            "TCabin" : TCabin,
            "TCabinSetPoint" : TCabinSetPoint,
            "rSoC"  : rSoC,
            "sRange" : sRange,
            "sRangeIncrease" : sRangeIncrease,
            "sVehicleTotal" : sVehicleTotal,
            "sVehicleTrip" : sVehicleTrip,
            "tChargingRemaining" : tChargingRemaining,
            "vLimit" : vLimit,
            "NBonnetStatus" : NBonnetStatus,
            "NBootStatus" : NBootStatus,
            "NCarSecureStatus" : NCarSecureStatus,
            "NChargerCapStatus" : NChargerCapStatus,
            "NClimateStatus" : NChargerCapStatus,
            "NDefrostStatus" : NDefrostStatus,
            "NDoorDriverStatus" : NDoorDriverStatus,
            "NDoorPaxStatus" : NDoorPaxStatus,
            "NLowBeamHeadStatus" : NLowBeamHeadStatus,
            "NPLimitEnable"  : NPLimitEnable,
            "NWarningLightStatus" : NWarningLightStatus,
            "NvLimitEnable" : NvLimitEnable,
            "token" : token,
            "vehicleDescription" : vehicleDescription,
          };
  }

}