//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:qevapp/providers/vehicle_provider.dart';
//import 'package:qevapp/app_localizations.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:qevapp/core/models/vehicle_model.dart';

class KeyView extends StatefulWidget {
  @override
  _KeyViewState createState() => _KeyViewState();
}

class _KeyViewState extends State<KeyView> {
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _vehicleId;

  void _setVehicleId(String vehicleId) async {
    setState(() {
      _vehicleId = vehicleId;
    });
  }

  void ButtonClick() {
    print("Button is clicked");
  }

  @override
  Widget build(BuildContext context) {
    //AppLocalizations localizations = AppLocalizations.of(context);
    //final vehicleProvider = Provider.of<VehicleProvider>(context);
    //Stream<QuerySnapshot> stream =
    //vehicleProvider.fetchVehicleByKeyValueAsStream('vehicleId', _vehicleId);

    Column _buildButtonColumn(Color color, IconData icon, String label,
        double fsize, double isize, double margin) {
      return Column(children: [
        FlatButton(
          shape: CircleBorder(
            side: BorderSide(color: Colors.grey),
          ),
          onPressed: ButtonClick,
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
            "Label" ,//localizations.t(label),
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _BatteryRange.toString(),
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          ),
          Text(
            "Range",//localizations.t('key.range'),
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          ),
          //TODO: A PARTIR DE AQUÍ SOLO CUANDO EL VEHICULO ESTÉ CARGANDO!!!!!
          SizedBox(width: 10),
          Image.asset(
            'assets/mipmap/mipmap-hdpi/ic_home_power.png',
            scale: 6.0,
            color: Colors.tealAccent,
          ),
          SizedBox(width: 2),
          Text(
            "Charging",
            //localizations.t('key.charging'),
            style: TextStyle(fontSize: 13.0, color: Colors.tealAccent),
          ),
        ],
      );
    }

    Widget getStack(Vehicle _vehicle) {
      String def_asset = 'assets/mipmap/mipmap-hdpi/Key_View/default.png';
      String assetLights;
      String assetWarnings;
      String assetCar;

      if (_vehicle.NLowBeamHeadStatus == 1) {
        //TODO: Comprobar los valores de NDriverDoor
        assetLights = 'assets/mipmap/mipmap-hdpi/Key_View/key_lights.png';
      } else {
        assetLights = def_asset;
      }
      if (_vehicle.NWarningLightStatus == 1) {
        //TODO: Comprobar los valores de NWarningLights
        assetWarnings =
        'assets/mipmap/mipmap-hdpi/Key_View/warnings_lights.png';
      } else {
        assetWarnings = def_asset;
      }
      if (_vehicle.NDoorDriverStatus == 1 && _vehicle.NDoorPaxStatus == 0) {
        //TODO: Comprobar los valores de NDriverDoor
        assetCar = 'assets/mipmap/mipmap-hdpi/Key_View/open_left.png';
      } else if (_vehicle.NDoorDriverStatus == 0 &&
          _vehicle.NDoorPaxStatus == 1) {
        assetCar = 'assets/mipmap/mipmap-hdpi/Key_View/open_right.png';
      } else if (_vehicle.NDoorDriverStatus == 1 &&
          _vehicle.NDoorPaxStatus == 1) {
        assetCar = 'assets/mipmap/mipmap-hdpi/Key_View/open_car.png';
      } else {
        assetCar = 'assets/mipmap/mipmap-hdpi/Key_View/close_car.png';
      }
      //TODO: Faltaría añadir las imagenes del capó y el bonnet abiertas

      return Stack(children: [
        Image.asset(assetCar),
        Image.asset(assetLights),
        Image.asset(assetWarnings),
      ]);
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
        height: 125.0,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 15.0),
        child: Stack(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child:
                    Image.asset('assets/mipmap/mipmap-hdpi/ic_close.png'),
                  )),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 5),
                CircularPercentIndicator(
                  progressColor: currentProgressColor(_vehicle.rSoC),
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
                        _vehicle.rSoC.toString(),
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text("%"),
                    ],
                  ),
                ),
                Container(
                  //padding: const EdgeInsets.all(10),
                  child: editableText(_vehicle.sRange),
                ),
              ]),
        ]),
      );
    }

    Widget centerKey(Vehicle _vehicle) {
      //TODO: Falta añadir botones para Abrir Bonnet y Trunk
      return Container(
        width: double.infinity,
        child: Stack(children: [
          topKey(_vehicle),
          //TODO: SI EL COCHE ESTA LOCKED, BOTONES DE PUERTA TIENEN QUE ESTAR EN GRIS
          Positioned(
            bottom: 20,
            left: 10,
            child: _buildButtonColumn(
                Colors.white,
                Typicons.warning_outline,
                'key.ldoor', //TODO: CAMBIAR ICONO POR ICONO PUERTA
                12.0,
                35.0,
                17.5),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: _buildButtonColumn(
                Colors.white,
                Typicons.warning_outline,
                'key.rdoor', //TODO: CAMBIAR ICONO POR ICONO PUERTA
                12.0,
                35.0,
                17.5),
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonColumn(Colors.white, Typicons.warning_outline,
                'key.warning', 12.0, 35.0, 17.5),
            _buildButtonColumn(Colors.white, Icons.lightbulb_outline,
                'key.lights', 12.0, 30.0, 20.0),
            _buildButtonColumn(Colors.white, FlutterIcons.car_crash_faw5s,
                'key.honk', 12.0, 30.0, 20.0),
//          _buildButtonColumn(Colors.white, Icons.lock, 'key.lock',12.0,25.0,20.0), //TODO: Cambiar icono y mensaje en funcion de estado vehículo.Vehicle Open
            _buildButtonColumn(
                Colors.white, Icons.lock_open, 'key.unlock', 12.0, 30.0, 20.0),
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
            child: StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    if (snapshot.data.docs.length > 0) {
                      Vehicle vehicle;
                      Vehicle.fromMap(snapshot.data.docs.first.data());
                      return Column(children: [
                        Expanded(
                          child: centerKey(vehicle),
                        ),
                        bottomKey(vehicle),
                      ]);
                    } else {
                      //TODO: ESTA PAGINA FUNCIONA CON BLUETOOTH SOLO
                      return Text('Vehicle not found...');
//                      return Text('You are too far from the vehicle...');
                    }
                  } else {
                    return Text('Vehicle not found...');
//                    return Text('You are too far from the vehicle...');
                  }
                }),
          ),
        ),
      ),
    );
  }
}
h