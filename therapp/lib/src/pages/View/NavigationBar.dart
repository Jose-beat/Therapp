import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/pages/Register/RegistrarPaciente.dart';
import 'package:therapp/src/pages/View/Calendar.dart';
import 'package:therapp/src/pages/View/Configure.dart';
import 'package:therapp/src/pages/View/HomePage.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerTerapeuta.dart';
import 'package:therapp/src/pages/View/example.dart';
import 'package:therapp/src/providers/authentApp.dart';

class NavigationAppBar extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;
  final String userId;
  NavigationAppBar(
      {Key key,
      this.auth,
      this.loginCallback,
      this.logoutCallback,
      this.userId})
      : super(key: key);

  @override
  _NavigationAppBarState createState() => _NavigationAppBarState();
}

class _NavigationAppBarState extends State<NavigationAppBar> {
  int _cIndex = 0;

  void _incrementTab(int index) {
    setState(() {
      _cIndex = index;
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _opciones = [
      HomePage(
        auth: widget.auth,
        loginCallback: widget.loginCallback,
        logoutCallback: widget.logoutCallback,
        userId: widget.userId,
      ),
     ConsultasActuales(),
      RegistrarPaciente(
        paciente: Paciente(null, '', '', 0, '', '', widget.userId),
        userId: widget.userId,
      ),
      Configure(),
    ];
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  _createNewPaciente(context);
                },
                child: Text('crear paciente')),
            FlatButton(onPressed: signOut, child: Text('Cerrar Sesion')),
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.supervised_user_circle),
                radius: 20.0,
              ),
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerTerapeuta(
                              userId: widget.userId,
                              auth: widget.auth,
                              logoutCallback: widget.logoutCallback,
                            )));
              },
            ),
          ],
        ),
        body: Center(child: _opciones.elementAt(_cIndex)),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          currentIndex: _cIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                color: Colors.grey,
                size: 20.5,
              ),
              title: Text(
                'Expedientes',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, color: Colors.grey,  size: 20.5,),
              title: Text(
                'Calendario',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add, color: Colors.grey,  size: 20.5,),
                title: Text(
                  'Añadir Paciente',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.build, color: Colors.grey,  size: 20.5,),
                title: Text('Configuracion', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        ));
  }

  void _createNewPaciente(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrarPaciente(
                  paciente: Paciente(null, '', '', 0, '', '', widget.userId),
                  userId: widget.userId,
                )));
  }
}
