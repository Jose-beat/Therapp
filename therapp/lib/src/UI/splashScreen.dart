import 'dart:async';

import 'package:flutter/material.dart';
import 'package:therapp/src/providers/authentApp.dart';
import 'package:therapp/src/providers/routes.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class BatmanPageRoute extends PageRouteBuilder{

  final Widget child;

  BatmanPageRoute(this.child)
  :super (
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
      return child;
    },
    transitionsBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
      return Transform.scale(
        scale: animation.value,
              child: FadeTransition(
          child: child,
          opacity: animation,
          ),
      );
    }
  );



}




class _SplashScreenState extends State<SplashScreen> {

  
  Future<Timer>startTime()async{
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

   void navigationPage()async{
    Navigator.of(context).pushReplacement(
      BatmanPageRoute( RootPage(auth: Autho(),) ));
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