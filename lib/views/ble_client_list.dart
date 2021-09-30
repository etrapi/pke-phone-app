import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hispanosuizaapp/models/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue/flutter_blue.dart';


class BleClientList extends StatefulWidget {
  BleClientList({Key key, this.title}) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _BleClientListState createState() => _BleClientListState();
}

class _BleClientListState extends State<BleClientList> {
  final _writeController = TextEditingController();
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
        _pkeCharacteristic = chpke;
        _cmdCharacteristic = chcmd;

      });
    }

  }

  _resetConnection() async {
      await _connectedDevice.disconnect();
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
      try {
        await _pkeCharacteristic.write(_pkeData);
      } on PlatformException {
        await Future.delayed(Duration(milliseconds: 100));
      } catch (e) {
          print ("PKE" + e.toString());
          await _resetConnection();

        throw e;
      }
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
        throw e;
      }
    }while (retry <3);
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

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    if (e.code != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = new List<ButtonTheme>();

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = new List<Container>();

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = new List<Widget>();

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  Container _buildView() {
    //if (_connectedDevice == null) {
    //  return Container(child: _buildListViewOfDevices());
    //}
    return
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Expanded(
            //  child: _buildConnectDeviceView(),
            //
            SizedBox(
              height: 10.0,
            ),
            if (_connectedDevice==null)
              Icon(
                Icons.bluetooth,
                size: 50,
                color: Colors.grey
              )
            else
              Icon(
                Icons.bluetooth_connected,
                size: 50,
                color: Colors.blue,
                ),
            _connectedDevice==null?Text ( " " ): Text ("Connected to Vehicle: "+ vehicleId ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                icon: const Icon(Icons.sensor_door_outlined),
                tooltip: 'Left door',
                iconSize: 30,
                onPressed: () => _writeCmdData (1,0)
              ),
                IconButton(
                    icon: const Icon(Icons.shopping_bag),
                  tooltip: 'Trunk',
                  iconSize: 30,
                  onPressed: () => _writeCmdData (4,0)
                ),
                IconButton(
                  icon: const Icon(Icons.highlight_sharp),
                  tooltip: 'Low Beam',
                    iconSize: 30,
                  onPressed: () => _writeCmdData (6,0)
                ),
                IconButton(
                  icon: const Icon(Icons.warning),
                  tooltip: 'Warning Lights',
                    iconSize: 30,
                  onPressed: () =>_writeCmdData (3,0)
                ),
                IconButton(
                  icon: const Icon(Icons.electrical_services),
                  tooltip: 'Charging Inlet',
                    iconSize: 30,
                  onPressed: () => _writeCmdData (7,0)
                ),
                IconButton(
                  icon: const Icon(Icons.electric_car_sharp),
                  tooltip: 'Bonnet',
                    iconSize: 30,
                  onPressed:  () =>_writeCmdData (5,0)
                ),
                IconButton(
                  icon: const Icon(Icons.sensor_door_outlined),
                  tooltip: 'Right door',
                    iconSize: 30,
                  onPressed:  () =>_writeCmdData (2,0)
                ),
    ]
            ),

          ],
        ),
      );
  }


  @override
  Widget build(BuildContext context) => Scaffold(

    body: SafeArea(
          child: _buildView(),
          )
  );
}