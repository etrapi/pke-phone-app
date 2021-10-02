//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/providers/vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:hispanosuizaapp/models/vehicle_model.dart';

class KeyView extends StatefulWidget {
  @override
  _KeyViewState createState() => _KeyViewState();
}

class _KeyViewState extends State<KeyView> {
  final myController = TextEditingController();

  void ButtonClick(String label) {
    print("Button: " + label + " is clicked");
  }

  @override
  Widget build(BuildContext context) {
    //AppLocalizations localizations = AppLocalizations.of(context);
    VehicleProvider _vehicleProvider = Provider.of<VehicleProvider>(context);
    Vehicle vehicle = _vehicleProvider.vehicle;

    Column _buildButtonColumn(Color color, IconData icon, String label,
        double fsize, double isize, double margin) {
      return Column(children: [
        FlatButton(
          shape: CircleBorder(
            side: BorderSide(color: Colors.grey),
          ),
          onPressed: () => {ButtonClick(label)},
          child: Icon(
            icon,
            color: color,
            size: isize,
          ),
          highlightColor: Colors.blueGrey,
          padding: EdgeInsets.all(margin),
        ),
        // Container(
        //   margin: const EdgeInsets.only(top: 8),
        //   child: Text(
        //     "Label" ,//localizations.t(label),
        //     style: TextStyle(
        //       fontSize: fsize,
        //       fontWeight: FontWeight.w400,
        //       color: color,
        //     ),
        //   ),
        // ),
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
            " RANGE", //localizations.t('key.range'),
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
              "CHARGING...",
              //localizations.t('key.charging'),
              style: TextStyle(fontSize: 13.0, color: Colors.tealAccent),
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
        margin: const EdgeInsets.all(35.0),
        height: MediaQuery.of(context).size.height * 0.55,
        child: Stack(children: [
          Container(alignment: Alignment.center,child:Image.asset(assetCarClosed)),
          if (_vehicle.NDoorDriverStatus == 1) Container(alignment: Alignment.center,child:Image.asset(assetCarLeft)),
          if (_vehicle.NDoorPaxStatus == 1) Container(alignment: Alignment.center,child:Image.asset(assetCarRight)),
          if (_vehicle.NBonnetStatus == 1) Container(alignment: Alignment.center,child:Image.asset(assetCarFront)),
          if (_vehicle.NBootStatus == 1) Container(alignment: Alignment.center,child:Image.asset(assetCarBack)),
          if (_vehicle.NLowBeamHeadStatus == 1) Container(alignment: Alignment.center,child:Image.asset(assetLights)),
          if (_vehicle.NWarningLightStatus == 1) Container(alignment: Alignment.center,child:Image.asset(assetWarnings)),
          if (_vehicle.NChargerCapStatus == 1) Container(alignment: Alignment.center, child:Image.asset(assetCarCharger)),
          Container(              alignment: Alignment.center,
              child: Icon(Icons.bluetooth_connected_outlined, color: Colors.blueAccent.withOpacity(0.45))),
          Container(
              color: Colors.transparent,
              //height: 300,
              //width: 300,
              //child: Material(
              //  color: Colors.transparent,
                child: InkResponse(
                  //borderRadius: BorderRadius.circular(80),
                  splashColor: Colors.grey.withOpacity(0.45),
                  highlightColor: Colors.transparent,
                onTap: () {
                 print("Tapped on container");
                },

            ),
            //  ),
          )
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
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(height: 5),
            CircularPercentIndicator(
              progressColor: currentProgressColor((vehicle.rSoC.toInt())),
              backgroundColor: Color(0x884676),
              percent: _vehicle.rSoC/100,
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
        child: Stack(children: [
          topKey(_vehicle),
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

            // _buildButtonColumn(Colors.white, FlutterIcons.car_crash_faw5s,
            //     'key.honk', 12.0, 30.0, 20.0),
//          _buildButtonColumn(Colors.white, Icons.lock, 'key.lock',12.0,25.0,20.0), //TODO: Cambiar icono y mensaje en funcion de estado vehículo.Vehicle Open
            //
            _buildButtonColumn(
                Colors.white, Icons.electrical_services, 'key.inlet', 12.0, 30.0, 20.0),
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
