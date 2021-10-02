import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hispanosuizaapp/providers/local_storage_provider.dart';
import 'package:hispanosuizaapp/providers/vehicle_provider.dart';
import 'package:hispanosuizaapp/ui/views/home_view.dart';
import 'package:hispanosuizaapp/ui/views/login_view.dart';
import 'package:hispanosuizaapp/app_localizations.dart';
import 'package:hispanosuizaapp/providers/login_provider.dart';


final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xff1d1d26),
  scaffoldBackgroundColor:  Colors.black,
  accentColor: Colors.tealAccent,//Colors.yellow[700],
  accentIconTheme: IconThemeData(color: Colors.tealAccent),
  dividerColor: Colors.black12,
  fontFamily: 'Dinpro',
);

final defaultTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// Global [SharedPreferences] object.
SharedPreferences prefs;

Future<void> main() async {
  /*prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(countKey)) {
    await prefs.setInt(countKey, 0);
  }*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => VehicleProvider()),
          ChangeNotifierProvider(create: (context) => LocalStorageProvider()),
          ChangeNotifierProvider (create: (context) => LoginProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hispano-Suiza Cars',
          theme: darkTheme,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => HomeView()
            );
          },
          routes: {
            '/': (BuildContext context) {
              var login = Provider.of<LoginProvider>(context);
              if (login.isLoggedIn()) {
                return HomeView();
              } else {
                return LoginView();
              }
            },
          },
          supportedLocales: [
            Locale('en'),
            Locale('es'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        )
    );
  }
}
