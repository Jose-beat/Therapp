import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/pages/Register/RegistrarPaciente.dart';
import 'package:therapp/src/pages/View/Calendar.dart';
import 'package:therapp/src/pages/View/Configure.dart';
import 'package:therapp/src/pages/View/HomePage.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerTerapeuta.dart';
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


enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class _NavigationAppBarState extends State<NavigationAppBar> {

   WhyFarther _onSelected;

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

/*El arrelgo que contiene  acada una de las pantallasa mostrar al usuario segun indique en los botones de navegacion*/
    List<Widget> _opciones = [
      /*Pagia principal*/
      HomePage(
        auth: widget.auth,
        loginCallback: widget.loginCallback,
        logoutCallback: widget.logoutCallback,
        userId: widget.userId,
      ),
      /*Pagina de calendario*/
     ConsultasActuales(),

/*Pagina para crear el expediente de paciente */
     RegistrarPaciente(
        paciente: Paciente(null, '', '','' ,0, '', '', widget.userId,''),
        userId: widget.userId,
      ),


    ];





    return MaterialApp(
      themeMode: ThemeMode.dark,
          home: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return perfil();
              },
            ), 
            actionsIconTheme: IconThemeData(
              color: Colors.black
            ),
            actions: <Widget>[
            
              FlatButton(onPressed: signOut, child: Text('Cerrar Sesion')),
           
            ],
          ),

          /*Aqui se muestra la pantalla indicada por el metodo elementAt seugn la lista*/
          body: Center(child: _opciones.elementAt(_cIndex)),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            currentIndex: _cIndex,
            type: BottomNavigationBarType.fixed,
            /*-----------------------------------CONJUNTO DE ICONOS DE NAVEGACION ENTRE INTERFACES DE LA APP-----------------------*/
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
            /*Ejecucion del metodo que incrementa la variable index que controla la posicion de las paginas en la pantalla principal */
            onTap: (index) {
              _incrementTab(index);
            },
          )),
    );
  }





  /*-------------------------METODO QUE INICIALIZA EL REGISTRO DE UN PACIENTE---------------------------*/

  void _createNewPaciente(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrarPaciente(
                  paciente: Paciente(null, '', '','', 0, '', '', widget.userId,''),
                  userId: widget.userId,
                )));
  }



/*---------------BOTON DE PERFIL--------------------------------*/
Widget perfil(){
  return    IconButton(
             
             icon: Icon(Icons.supervised_user_circle),
                
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
            );
}



/*-------------------------------------OPCIONES DESPLEGABLES----------------------------*/

Widget _simplePopup() => PopupMenuButton<int>(
  child: Icon(Icons.menu),
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("First"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Second"),
                ),
              ],
        );


}
