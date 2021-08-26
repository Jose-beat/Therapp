import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:therapp/src/UI/splashScreen.dart';
//import 'package:therapp/src/providers/authentApp.dart';
import 'package:therapp/src/providers/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(TherApp()));
}

class TherApp extends StatelessWidget {
  const TherApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TherApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: SplashScreen(),
      routes: routes,
      
      /*
      title: 'TherApp',
      home: RootPage(
        auth: Autho(),
      ),*/
    );
  }
}
