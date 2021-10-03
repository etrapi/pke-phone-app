//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hispanosuizaapp/providers/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:hispanosuizaapp/core/models/vehicle_model.dart';
import 'package:hispanosuizaapp/app_localizations.dart';


//TODO: Separar servicio Ble de UI
class KeyView extends StatefulWidget {
  final String title = "";
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  @override
  _KeyViewState createState() => _KeyViewState();
}

class _KeyViewState extends State<KeyView> {
  static const bool _demo = true; //Turn on demo mode
  final myController = TextEditingController();
  BluetoothDevice _connectedDevice;
  BluetoothCharacteristic _pkeCharacteristic;
  BluetoothCharacteristic _cmdCharacteristic;
  List<BluetoothService> _services;
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  final _commands = <bool> [];
  bool _isScanning = false;
  int keyId = 0x0A;
  String vehicleId = '00000003';
  int count = 0;

  _initStreams () {
    widget.flutterBlue.isScanning
        .listen((p) => setState(() => _isScanning = p),);
    //widget.flutterBlue.state.listen((event) {print ("evento: " + event.toString());});
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
        print ("Nombre de dispositivo" + device.name);
      }
    }
    );
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      BluetoothDevice pke;
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
        if (result.device.name == 'PKE2') pke = result.device;
      }
      print ("busco PKE");
      if (pke!=null){
        print ("encuentro el PKE");
        _connectDevice (pke);
      }
    });
  }

  _startDevicesDiscovery()  {
    if (!_isScanning) {
      widget.flutterBlue.startScan();
      print("Discovery Services ON");
    }
  }

  _stopDevicesDiscovery() {
    if (_isScanning) {
      widget.flutterBlue.stopScan();
      print("Discovery Services OFF");
    }
  }

  _connectDevice(final BluetoothDevice device) async {
    BluetoothCharacteristic chpke;
    BluetoothCharacteristic chcmd;
    _stopDevicesDiscovery();
    try {
      await device.connect();
    } catch (e) {

      if (e.code != 'already_connected') {
        throw e;
      }
    } finally {
      _services = await device.discoverServices();
      for (BluetoothService service in _services) {
        if (service.uuid == Guid("d9b9ec1f-3925-43d0-80a9-1e00"+vehicleId))
          for (BluetoothCharacteristic characteristic
          in service.characteristics) {
            print('(S1)' + service.uuid.toString());
            if (characteristic.uuid ==
                Guid("d9b9ec1f-3925-43d0-80a9-1e11"+vehicleId)) {
              chpke = characteristic;
              print('  (C1)' + characteristic.uuid.toString());
            }
          }
        if (service.uuid == Guid("d9b9ec1f-3925-43d0-80a9-1e01"+vehicleId))
          for (BluetoothCharacteristic characteristic
          in service.characteristics) {
            print('(S2)' + service.uuid.toString());
            if (characteristic.uuid ==
                Guid("d9b9ec1f-3925-43d0-80a9-1e21"+vehicleId)) {
              chcmd = characteristic;
              print('  (C2)' + characteristic.uuid.toString());
            }
          }
      }

      setState(() {
        _connectedDevice = device;
        print ("El puto dispositivo conectado se llama:" + device.name);
        _pkeCharacteristic = chpke;
        _cmdCharacteristic = chcmd;

      });
    }

  }

  _resetConnection() async {
    if (_connectedDevice != null) {
      await _connectedDevice.disconnect();
    }
    await _startDevicesDiscovery ();
    setState(() {
      _connectedDevice = null;
      _pkeCharacteristic = null;
    });

  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      //print (device.name);
      //device.services.forEach((element) {print(element.toString());});
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  _initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    final regions = <Region>[];
    regions.add(Region(
        identifier: 'PKEAnchor1',
        proximityUUID: 'd9b9ec1f-3925-43d0-80a9-1e31' + vehicleId));
    regions.add(Region(
        identifier: 'PKEAnchor2',
        proximityUUID: 'd9b9ec1f-3925-43d0-80a9-1e32'+ vehicleId));
    regions.add(Region(
        identifier: 'PKEAnchor3',
        proximityUUID: 'd9b9ec1f-3925-43d0-80a9-1e33'+ vehicleId));
    regions.add(Region(
        identifier: 'PKEAnchor4',
        proximityUUID: 'd9b9ec1f-3925-43d0-80a9-1e34' + vehicleId));
    regions.add(Region(
        identifier: 'PKEAnchor5',
        proximityUUID: 'd9b9ec1f-3925-43d0-80a9-1e35'+ vehicleId));

    if (_streamRanging != null) {
      if (_streamRanging.isPaused) {
        _streamRanging.resume();
        return;
      }
    }

    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
          if (result != null && mounted) {
            setState(() {
              _regionBeacons[result.region] = result.beacons;
              _beacons.clear();
              _regionBeacons.values.forEach((list) {_beacons.addAll(list);
              });
              _beacons.sort(_compareParameters);

            });
          }
        });
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }
  _writePkeData ()  async {
    List<int> _pkeData = [-128, -128, -128, -128, -128, keyId];
    bool _iBeaconCentralRx = false; //add timeout 5s
    if(_connectedDevice !=null && _pkeCharacteristic != null) {
      if (_beacons.isNotEmpty) {
        for (int j = 0; j < _beacons.length; j++) {
          Beacon element = _beacons[j];
          if (element.proximityUUID.contains(
              "D9B9EC1F-3925-43D0-80A9-1E31" + vehicleId)) {
            _pkeData[0] = element.rssi;
          } else if (element.proximityUUID.contains(
              "D9B9EC1F-3925-43D0-80A9-1E32" + vehicleId)) {
            _iBeaconCentralRx = true;
            _pkeData[1] = element.rssi;
          } else if (element.proximityUUID.contains(
              "D9B9EC1F-3925-43D0-80A9-1E33" + vehicleId)) {
            _pkeData[2] = element.rssi;
          } else if (element.proximityUUID.contains(
              "D9B9EC1F-3925-43D0-80A9-1E34" + vehicleId)) {
            _pkeData[3] = element.rssi;
          } else if (element.proximityUUID.contains(
              "D9B9EC1F-3925-43D0-80A9-1E35" + vehicleId)) {
            _pkeData[4] = element.rssi;
          }
        }
      }
    }
    var retry = 0;
    do {
      try {
        count++;
        await _pkeCharacteristic.write(_pkeData);
        break;
      } on PlatformException {
        await Future.delayed(Duration(milliseconds: 100));
        retry ++;
      } catch (e) {
        print("PKE Write Exception: " + e.toString());
        await _resetConnection();
        retry ++;
        //throw e;
      }
    } while (retry < 10);
  }


  _writeCmdData (int cmd, int payload) async {
    List<int> _cmdData = [0, 0];
    var retry = 0;
    do {
      try {
        _cmdData[0] = cmd;
        _cmdData[1] = count;
        count++;
        await _cmdCharacteristic.write(_cmdData);
        break;
      } on PlatformException {
        await Future.delayed(Duration(milliseconds: 50));
        print("CMD pattform exception");
        retry ++;
      } catch (e) {
        print("CMD" + e.toString());
        await _resetConnection();
        retry ++;
        //throw e;
      }
    }while (retry < 3);
  }

  @override
  void initState() {
    super.initState();
    _initStreams ();
    _startDevicesDiscovery ();
    _initScanBeacon();
    Timer.periodic(Duration(milliseconds: 5000), (timer) {
      print(DateTime.now());
      _writePkeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    VehicleProvider _vehicleProvider = Provider.of<VehicleProvider>(context);
    Vehicle vehicle = _vehicleProvider.vehicle;

    void _buttonClick(String label) {
      print("Button: " + label + " is clicked");
      if (_demo) {
        if (label == "key.inlet") _vehicleProvider.cmdInlet();
        if (label == "key.warning") _vehicleProvider.cmdWarning();
        if (label == "key.lights") _vehicleProvider.cmdLights();
        if (label == "key.ldoor") _vehicleProvider.cmdDriverDoor();
        if (label == "key.rdoor") _vehicleProvider.cmdPaxDoor();
        if (label == "key.bonnet") _vehicleProvider.cmdBonnet();
        if (label == "key.boot") _vehicleProvider.cmdBoot();
      } else {
        if (label == "key.inlet") _writeCmdData (7,0);
        if (label == "key.warning") _writeCmdData (3,0);
        if (label == "key.lights") _writeCmdData (6,0);
        if (label == "key.ldoor") _writeCmdData (1,0);
        if (label == "key.rdoor") _writeCmdData (2,0);
        if (label == "key.bonnet") _writeCmdData (5,0);
        if (label == "key.boot") _writeCmdData (4,0);
      }
    }

    Column _buildButtonColumn(Color color, IconData icon, String label,
        double fsize, double isize, double margin) {
      return Column(children: [
        FlatButton(
          shape: CircleBorder(
            side: BorderSide(color: Colors.grey),
          ),
          onPressed: () => {_buttonClick(label)},
          child: Icon(
            icon,
            color: color,
            size: isize,
          ),
          highlightColor: Colors.blueGrey,
          padding: EdgeInsets.all(margin),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            localizations.t(label),
            style: TextStyle(
              fontSize: fsize,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ]);
    }

    Widget editableText(int _BatteryRange) {
      if (_connectedDevice != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _BatteryRange.toString(),
              style: TextStyle(fontSize: 13.0, color: Colors.white),
            ),
            Text(
              localizations.t('key.range'),
              style: TextStyle(fontSize: 13.0, color: Colors.white),
            ),
            //TODO: A PARTIR DE AQUÍ SOLO CUANDO EL VEHICULO ESTÉ CARGANDO!!!!!
            SizedBox(width: 10),
            if (vehicle.BCharging)
              Image.asset(
                'assets/mipmap/mipmap-hdpi/ic_home_power.png',
                scale: 6.0,
                color: Colors.tealAccent,
              ),
            SizedBox(width: 2),
            if (vehicle.BCharging)
              Text(
                //"cNG...",
                localizations.t('key.charging'),
                style: TextStyle(fontSize: 13.0, color: Colors.tealAccent),
              ),
          ],
        );
      }else {
        return Center(
          child: Text(
            localizations.t('key.blesearch'),
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          ),
        );
      }
    }

    Widget getTouchAreas() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            //color: Colors.blue,
            height: MediaQuery.of(context).size.height * 0.10,
            width: MediaQuery.of(context).size.width * 0.33,
            decoration: BoxDecoration(
              border: Border.all(
                color: _demo ? Colors.tealAccent : Colors.transparent,
              )
            ),
            child: Material(
                color: Colors.transparent,
                child: InkResponse(
                    borderRadius: BorderRadius.circular(200),
                    splashColor:  Colors.tealAccent.withOpacity(0.25),
                    highlightColor: Colors.transparent,
                    containedInkWell: true,
                    onTap: () => _buttonClick('key.bonnet'))
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _demo ? Colors.tealAccent : Colors.transparent,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Material(
                  color: Colors.transparent,
                  child: InkResponse(
                      borderRadius: BorderRadius.circular(200),
                      splashColor: Colors.tealAccent.withOpacity(0.25),
                      highlightColor: Colors.transparent,
                      containedInkWell: true,
                      onTap: () => _buttonClick('key.ldoor'))
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _demo ? Colors.tealAccent : Colors.transparent,
                ),
                shape: BoxShape.rectangle,
              ),
              child: Material(
                  color: Colors.transparent,
                  child: InkResponse(
                      borderRadius: BorderRadius.circular(200),
                      splashColor: Colors.tealAccent.withOpacity(0.25),
                      highlightColor: Colors.transparent,
                      containedInkWell: true,
                      onTap: () =>  _buttonClick('key.rdoor'))),
            )
          ]),
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width * 0.33,
            decoration: BoxDecoration(
              border: Border.all(
                color: _demo ? Colors.tealAccent : Colors.transparent,
              ),
              shape: BoxShape.rectangle,
            ),
            child: Material(
                color: Colors.transparent,
                child: InkResponse(
                    borderRadius: BorderRadius.circular(200),
                    splashColor: Colors.tealAccent.withOpacity(0.25),
                    highlightColor: Colors.transparent,
                    containedInkWell: true,
                    onTap: () =>  _buttonClick('key.boot'))),
          ),
        ],
      );
    }

    Widget getStack(Vehicle _vehicle) {
      String assetLights =
          'assets/mipmap/mipmap-hdpi/Key_View/Lights on@3x.png';
      String assetWarnings =
          'assets/mipmap/mipmap-hdpi/Key_View/warnings_lights.png';
      String assetCarLeft =
          'assets/mipmap/mipmap-hdpi/Key_View/DOOR_LEFT_V_.png';
      String assetCarRight =
          'assets/mipmap/mipmap-hdpi/Key_View/DOOR_RIGHT_V_.png';
      String assetCarClosed =
          'assets/mipmap/mipmap-hdpi/Key_View/DOOR_ALL_CLOSED_V_.png';
      String assetCarFront =
          'assets/mipmap/mipmap-hdpi/Key_View/DOOR_FRONT_V_.png';
      String assetCarBack =
          'assets/mipmap/mipmap-hdpi/Key_View/DOOR_BACK_V_.png';
      String assetCarCharger =
          'assets/mipmap/mipmap-hdpi/Key_View/DOOR_CHARGE_V_.png';

      //TODO: Faltaría añadir las imagenes del capó y el bonnet abiertas
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.45,
        child: Stack(children: [
          Container(
              alignment: Alignment.center,
              child: Image.asset(assetCarClosed)),
          if (_vehicle.NDoorDriverStatus == 1)
            Container(
                alignment: Alignment.center,
                child: Image.asset(assetCarLeft)),
          if (_vehicle.NDoorPaxStatus == 1)
            Container(
                alignment: Alignment.center,
                child: Image.asset(assetCarRight)),
          if (_vehicle.NBonnetStatus == 1)
            Container(
                alignment: Alignment.center,
                child: Image.asset(assetCarFront)),
          if (_vehicle.NBootStatus == 1)
            Container(
                alignment: Alignment.center,
                child: Image.asset(assetCarBack)),
          if (_vehicle.NLowBeamHeadStatus == 1)
            Container(
                margin: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
                child: Image.asset(assetLights)),
          if (_vehicle.NWarningLightStatus == 1)
            Container(
                alignment: Alignment.center,
                child: Image.asset(assetWarnings)),
          if (_vehicle.NChargerCapStatus == 1)
            Container(
                alignment: Alignment.center,
                child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(assetCarCharger))
            ),
          // if (_connectedDevice!=null) Container(
          //     alignment: Alignment.center,
          //     child:
          //       Icon(
          //         Icons.bluetooth_connected_outlined,
          //         color: Colors.blueAccent.withOpacity(0.55)
          //       )
          // )
          //,
          getTouchAreas(),
        ]),
      );
    }

    currentProgressColor(int progress) {
      if (progress <= 25 && progress > 10) {
        return Colors.yellowAccent;
      }
      if (progress <= 10) {
        return Colors.redAccent;
      } else {
        return Colors.tealAccent;
      }
    }

    Widget topKey(Vehicle _vehicle) {
      return Container(
        height: 150.0,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 15.0),
        child: Stack(children: [
          if (_connectedDevice == null )
              Center(child: SizedBox( width: 72, height: 72, child: CircularProgressIndicator(strokeWidth: 1.8,))),
          if (_connectedDevice == null )
              Center(child: SizedBox( width: 72, height: 72, child: Icon (Icons.bluetooth, color: Colors.tealAccent.withOpacity(0.75)))),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(height: 18),
            //if (_connectedDevice == null)
            //else
              if (_connectedDevice != null)CircularPercentIndicator(
              progressColor: currentProgressColor((vehicle.rSoC.toInt())),
              backgroundColor: Color(0x884676),
              percent: _vehicle.rSoC / 100,
              animation: true,
              radius: 75.0,
              lineWidth: 2.0,
              circularStrokeCap: CircularStrokeCap.round,
              center: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _vehicle.rSoC.toStringAsFixed(0),
                    style: TextStyle(fontSize: 26.0),
                  ),
                  Text("%"),
                ],
              ),
            ),
            Container(
              //padding: const EdgeInsets.all(10),
              child: editableText(_vehicle.sRange.toInt()),
            ),
          ]),
        ]),
      );
    }

    Widget centerKey(Vehicle _vehicle) {
      //TODO: Falta añadir botones para Abrir Bonnet y Trunk
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(children: [
          topKey(_vehicle),
          SizedBox(height: 40),
          Align(
            alignment: Alignment.bottomCenter,
            child: getStack(_vehicle),
          ),
        ]),
      );
    }

    Widget bottomKey(Vehicle _vehicle) {
      return Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButtonColumn(Colors.white, Icons.lightbulb_outline,
                'key.lights', 12.0, 30.0, 20.0),
            _buildButtonColumn(Colors.white, Typicons.warning_outline,
                'key.warning', 12.0, 35.0, 17.5),
            _buildButtonColumn(Colors.white, Icons.electrical_services,
                'key.inlet', 12.0, 30.0, 20.0),
            //Vehicle Locked
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/mipmap/mipmap-hdpi/Key_View/bg_key.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
              child: Column(children: [
            Expanded(
              child: centerKey(vehicle),
            ),
            bottomKey(vehicle),
          ])),
        ),
      ),
    );
  }
}