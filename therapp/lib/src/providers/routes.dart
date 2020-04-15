import 'package:flutter/material.dart';
import 'package:therapp/src/pages/View/NavigationBar.dart';
import 'package:therapp/src/pages/View/homePage.dart';
import 'package:therapp/src/pages/Login/loginApp.dart';
import 'package:therapp/src/pages/Register/registroPerfil.dart';
import 'package:therapp/src/providers/authentApp.dart';
//Lista de rutas principales en la app
Map<String, WidgetBuilder> routes = {
  'home': (BuildContext context) => LoginSignupPage(),
  'homePage': (BuildContext context) => HomePage(),
  'registro': (BuildContext context) => RegistroPerfil()
};
//Estados disponibles en la app
enum AuthStatus {
  NOT_DETERMINED, //no determinado 
  NOT_LOGGED_IN, //no logeado
  LOGGED_IN,  //Logeado
}
/*Esta clase se encarga de recibir los datos de la pagina de logueo 
para definir el concentimiento de acceso del usuario */
class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //estado inicial del logueo 
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    //Deiniremos si existe un usuario actual para verificar el iniciio de sesion
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }
//Definimos el estado actual de usuario al iniciar sesion
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }
//Definimos el estado actual de usuario al cerrar sesion
  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

//Definimos un widget de progreso en formato circular
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
//Aqui solo retornaremo la pagina segun el acceso del usuario (Logueado, no logueado o en registro pendiente)
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new NavigationAppBar(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
