import 'package:flutter/material.dart';
import 'package:hispanosuizaapp/providers/local_storage_provider.dart';
import 'package:hispanosuizaapp/providers/state_provider.dart';
import 'package:hispanosuizaapp/views/home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// Global [SharedPreferences] object.
SharedPreferences prefs;

Future<void> main() async {
  /*prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(countKey)) {
    await prefs.setInt(countKey, 0);
  }*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => StateProvider()),
          ChangeNotifierProvider(create: (context) => LocalStorageProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeView(title: 'Flutter Demo Home View'),
        ));
  }
}
