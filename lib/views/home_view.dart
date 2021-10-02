import 'package:flutter/material.dart';

import 'key_view.dart';


class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    //BleClientList(),
    KeyView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),*/
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
     /* bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          /*BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            title: Text('Futures'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fast_forward),
            title: Text('Streams'),
          ),*/
          /*BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            title: Text('Bluetooth'),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            title: Text('Ble Services'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            title: Text('Ble iBeacons'),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            title: Text('Settings'),*/
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),*/
    );
  }
}
