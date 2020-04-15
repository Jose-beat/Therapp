import 'dart:async';

import 'package:flutter/material.dart';
import 'package:therapp/src/providers/authentApp.dart';
import 'package:therapp/src/providers/routes.dart';


//ESTE MODULO SE ENCARGA DE CREAR UNA PANTALLA DE PRESENTACION
class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  //Metodo que funciona como cronometro el cual al cumplir dos segundos ejecutara el cambio de pagina de materialPage Route
  Future<Timer> startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }
//Este metodo solo nos llevara a la siguiente pagina que es la pagina de login
  void navigationPage() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: 
      (BuildContext context) => 
      RootPage(auth: Autho(),
    )));
  }
//Aqui declaramos el metodo para ejecutarlo al arrancar la app 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
//Diseño de la pagina de presentacion con el logo y nombre de la app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: showLogo(),
            
          ),
          Divider(
            color:Colors.white,
            height: 20.0,
          ),
          Center(
            child: Text(
              'TherApp',
            style: TextStyle(
              fontSize: 50.0,
              fontWeight:FontWeight.w200
            ),
            ),
            
          ),
        ],
      ),
    );
  }

//Metodo que dibuja el metodo y el nombre en el centro 
  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 88.0,
          child: Image.asset('assets/images/icon-app.jpeg'),
        ),
      ),
    );
  }
}
