import 'package:flutter/material.dart';
import 'package:therapp/src/providers/authentApp.dart';
import 'package:therapp/src/providers/routes.dart';

void main() {
  runApp(TherApp());
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
      home: RootPage(
        auth: Autho(),
      ),
      routes: routes,
    );
  }
}
