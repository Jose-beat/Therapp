import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:therapp/src/UI/splashScreen.dart';
import 'package:therapp/src/providers/authentApp.dart';
import 'package:therapp/src/providers/routes.dart';

void main() {
  
  initializeDateFormatting().then((_) => runApp(TherApp()));
}

class TherApp extends StatelessWidget {
  const TherApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      themeMode: ThemeMode.dark,
      title: 'TherApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
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
