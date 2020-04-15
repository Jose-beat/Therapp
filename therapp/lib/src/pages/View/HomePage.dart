import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/Terapeuta.dart';

import 'package:therapp/src/pages/Register/RegistrarPaciente.dart';
import 'package:therapp/src/pages/View/VerPaciente.dart';

import 'package:therapp/src/providers/authentApp.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;
  final String userId;

  const HomePage(
      {Key key,
      this.auth,
      this.loginCallback,
      this.userId,
      this.logoutCallback})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final pacienteReference =
    FirebaseDatabase.instance.reference().child('paciente');

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
       SnackBar snackBar = SnackBar(
                    content: Text(
                      'Debe insertar una foto de perfil',
                      style: TextStyle(decorationColor: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  );
  bool datos = true;
  int numeroPacientes = 0;
  double valor = 0.0;
  bool _cargando= true;
 
  List<Paciente> items;

  StreamSubscription<Event> _onPacienteAddedSubscription;
  StreamSubscription<Event> _onPacienteupdatedSubscription;

  Future<Timer> startTime() async {
    var _duration = Duration(seconds: 5);
    return Timer(_duration, cambioDatos);
  }


  @override
  void initState() {
  
    super.initState();
  
    
    items = new List();
    _onPacienteAddedSubscription =
        pacienteReference.onChildAdded.listen(_onPacienteAdded);
    _onPacienteupdatedSubscription =
        pacienteReference.onChildChanged.listen(_onPacienteUpdated);
  }

  @override
  void dispose() {
    super.dispose();
    _onPacienteAddedSubscription.cancel();
    _onPacienteupdatedSubscription.cancel();
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
    return Scaffold(
      body: Stack(children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                Text('No hay pacientes registrados', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                Text('Para crear un nuevo paciente pulse la pestaña', style: TextStyle(color: Colors.grey,  fontSize: 12.0)),
                Divider(
                  color:Colors.white
                ),
                Icon(Icons.person_add, color: Colors.grey,),
                Text('Añadir paciente', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      
        buildStream(),
       
      ]),
    );
  }

/*---------------------------METODOS PARA CREAR AL PÁCIENTE */

  void _navigateToPaciente(
      BuildContext context, Paciente paciente, String idTerapeuta) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerPaciente(
                  paciente: paciente,
                  idTerapeuta: idTerapeuta,
                )));
  }

  void _onPacienteAdded(Event event) {
    setState(() {
      items.add(new Paciente.fromSnapshot(event.snapshot));
    });
  }

  void _onPacienteUpdated(Event event) {
    var oldPacienteValue =
        items.singleWhere((paciente) => paciente.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldPacienteValue)] =
          new Paciente.fromSnapshot(event.snapshot);
    });
  }

  void _changePacienteInformation(
      BuildContext context, Paciente paciente) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrarPaciente(
                  paciente: paciente,
                  userId: widget.userId,
                  app: true,
                )));
  }
/*-------------------------------------METODOS TERAPEUTA--------------------------*/

  Widget _progresoCircular() {
    print(_cargando.toString());

    if (_cargando == true) {
      print(_cargando.toString());

      return Center(
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    } else {
      return Container();
    }
  }

 

  void cambioDatos() {
    setState(() {
      datos = !datos;
      _cargando = false;
    });
  }


  Widget _lista(){

    return   ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, position) {
             
              return _filter(context, position);
            },
          );
  
  }

  Widget _filter(BuildContext context, int position) {
    try{
      
      print("item :${items[position].id}");
      if (items[position].terapeuta == widget.userId) {
      print(_cargando.toString());
      numeroPacientes += 1;
      print('${items[position].id}');
      print('$position');
      print('NUMERO DE PACIENTES $numeroPacientes');
      return _paciente(context, position);
    } else {
      return Container(
      );
    }
    }catch(e){
      return Text(e);
    }
    


  }

  Widget _paciente(BuildContext context, int position) {
    return Card(
      child: Center(
        child: Column(
          children: <Widget>[
            ClipOval(
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
                fadeInCurve: Curves.bounceIn,
                placeholder: AssetImage('assets/images/icon-app.jpeg'),
                image: items[position].imagenPaciente != null
                    ? NetworkImage(
                        items[position].imagenPaciente + '?alt=media')
                    : AssetImage('assets/images/photo-null.jpeg'),
              ),
            ),
            Divider(),
            Text('${items[position].nombre} ${items[position].apellidos}',
               style: Theme.of(context).textTheme.subhead

               
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    color: Colors.teal[500],
                    hoverColor: Colors.teal[300],
                    onPressed: () => _navigateToPaciente(
                        context, items[position], widget.userId),
                    child: Text('Ver Expediente',
                    style: TextStyle(
                      color: Colors.white
                    ),
                    )),
                VerticalDivider(width: 10.0, color: Colors.black),
                FlatButton(
                    color: Colors.orange,
                    onPressed: () =>
                        _changePacienteInformation(context, items[position]),
                    child: Text('Editar Expediente',
                    style: TextStyle(
                      color: Colors.white
                    ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStream(){
    return StreamBuilder(
      stream: pacienteReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
       
        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
          
          return  _lista();
        }else{
        
          return  Center(
          
            child:Stack(
                          children:<Widget> [Column(
                mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[

                        Text( 'No se ha conectado a una red',
                        style: TextStyle(
                          color: Colors.red
                        ),),


                        Text( 'Favor de conectarse y reiniciar la aplicacion',
                        style: TextStyle(
                          color: Colors.grey
                        ), ),
                      Icon(
                        Icons.signal_wifi_off,
                        color: Colors.grey,
                          size: 100.0,
                       ),

                             
                  
                   

                    
                
                ]
              ),
            
              
              ]
            )
          );

          
        }
      }
      );
  }
}
