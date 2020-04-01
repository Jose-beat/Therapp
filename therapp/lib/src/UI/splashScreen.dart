import 'dart:async';

import 'package:flutter/material.dart';
import 'package:therapp/src/providers/authentApp.dart';
import 'package:therapp/src/providers/routes.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  Future<Timer>startTime()async{
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

   void navigationPage()async{
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)=> RootPage(auth: Autho(),) ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mira esta pantalla'),
      ),
    );
  }
}