import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Terapeuta.dart';
import 'package:therapp/src/pages/Login/LoginApp.dart';
import 'package:therapp/src/pages/Register/RegistroPerfil.dart';
import 'package:therapp/src/providers/authentApp.dart';


/*METODO PARA VER INFORMACION DE PERFIL*/
class VerTerapeuta extends StatefulWidget {
  final BaseAuth auth;
  final String userId;
  bool activado = true;
  final VoidCallback logoutCallback;
  VerTerapeuta(
      {Key key, this.userId, this.auth, this.logoutCallback, this.activado})
      : super(key: key);

  @override
  _VerTerapeutaState createState() => _VerTerapeutaState();
}
//METODO DE BASE DE DATOS 
final terapeutaReference =
    FirebaseDatabase.instance.reference().child('terapeuta');

class _VerTerapeutaState extends State<VerTerapeuta> {
  //METODOS INICIALES
  String nombres;
  //METODO PARA CERRAR SESION
  signOut() async {
    try {

      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  StreamSubscription<Event> _onTerapeutaAddedSubscription;
  StreamSubscription<Event> _onTerapeutaChangedSubscription;
  List<Terapeuta> items;
  String imagenTerapeuta;

  //METODOS INICIALES AL INICIAR LA PANTALLA 
  @override
  void initState() {
    super.initState();
    items = new List();
    _onTerapeutaAddedSubscription =
        terapeutaReference.onChildAdded.listen(_onTerapeutaAdded);
    _onTerapeutaChangedSubscription =
        terapeutaReference.onChildChanged.listen(_onTerapeutaUpdated);
  }
//DESTRUCCION DE VARIABLES ESCENCIALES
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onTerapeutaAddedSubscription.cancel();
    _onTerapeutaChangedSubscription.cancel();
  }
//METODO  PARA DIBUJAR LA PANTALLA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.activado ? AppBar(
          title: Text('Perfil'),
          backgroundColor: Colors.teal[300]
          ) : null,
        body: buildStream()
        );
  }

/*-------------------------------------------------------BACKEND Y CONTROL DE FIREBASE --------------------------------------- */

  void _onTerapeutaAdded(Event event) {
    setState(() {
      items.add(new Terapeuta.fromSnapshot(event.snapshot));
    });
  }

  void _onTerapeutaUpdated(Event event) {
    var oldTerapeutaValue =
        items.singleWhere((terapeuta) => terapeuta.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldTerapeutaValue)] =
          new Terapeuta.fromSnapshot(event.snapshot);
    });
  }

  void _deleteTerapeuta(
      BuildContext context, Terapeuta terapeuta, int position) async {
    await terapeutaReference.child(terapeuta.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
        widget.auth.deleteUser();
         
      });
      signOut();
      Navigator.pop(context);
    });
  
  }

  void _navigateToTerapeuta(BuildContext context, Terapeuta terapeuta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistroPerfil(
                terapeuta: terapeuta,
                email: terapeuta.email,
                imagenPerfil: false,
              )),
    );
  }

/*-------------------------------------FRONTEND Y FILTRO DE DATOS -----------------------------*/

  Widget _filter(BuildContext context, int position) {
    print("Usuario Actual :${items[position].id}");
    print("USER ID: ${widget.userId}");

    if (items[position].id == widget.userId) {
      print('${items[position].id}');

      return Column(
        children: <Widget>[
          /* FadeInImage(
            fadeInCurve: Curves.bounceIn,
            placeholder: AssetImage('assets/images/icon-app.jpeg'), 
            image: items[position].imagen != null ?
            NetworkImage(items[position].imagen + '?alt=media'):
            AssetImage('assets/images/photo-null.jpeg'),
            ),*/

          Container(
          
            child: ClipOval(
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 200.0,
                height: 200.0,
                fadeInCurve: Curves.bounceIn,
                placeholder: AssetImage('assets/images/icon-app.jpeg'),
                image: items[position].imagen != null
                    ? NetworkImage(items[position].imagen + '?alt=media')
                    : AssetImage('assets/images/photo-null.jpeg'),
              ),
            ),
          ),
         

          /* child: items[position].imagen == '' ? 
            Text('No hay imagen aun') :
            Image.network(items[position].imagen + '?alt=media')*/

          Divider(
            height: 7.0,
          ),
          _info(context, position)
        ],
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }
//METODO PARA EL FORMATO DE CADA ITEM
  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            subtitle: Text('Nombre del Terapeuta'),
            contentPadding: EdgeInsets.all(10.0),
            title: Row(
              children: <Widget>[
                Text('${items[position].nombre} ${items[position].apellidos}'),
              ],
            ),
          ),
          Divider(),
          _lista('Fecha de Nacimiento', items[position].nacimiento, context,
              position),
          Divider(),
          _lista(
              'Correo Electronico', items[position].email, context, position),
          Divider(),
          _lista('Clinica', items[position].clinica, context, position),
          Divider(),
          _lista(
              'Cedula Profesional', items[position].cedula, context, position),
          Divider(),
          _lista(
              'Especialidad', items[position].especialidad, context, position),
          Divider(),
          _lista('N.Telefonico', items[position].telefono, context, position),
          _update(context, items[position], position),
          _delete(context, items[position], position)
        ],
      ),
    );
  }
//METODO PARA EL FORMATO DE TODOS LOS ITEMS
  Widget _lista(
      String tipo, String variable, BuildContext context, int position) {
    return ListTile(
      subtitle: Text('$tipo'),
      title: Text('$variable'),
      /* IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToTerapeuta(context, items[position]))*/
    );
  }
//METODO QUE ELIMINARA Y CERRARALA SESION DEL USUARIO 
  Widget _delete(BuildContext context, Terapeuta terapeuta, int position) {
    return FlatButton(
      color: Colors.teal[500],
      child: Container(
        child: Row(
          children: <Widget>[
            Text('Eliminar Perfil', textAlign: TextAlign.right, style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
      onPressed: () => _confirmacion(context, items[position], position),
    );
  }
//MUESTRA DE ALERTCARD PARAB CONFIRMAR LA ELIMINACION 
  void _confirmacion(BuildContext context, Terapeuta terapeuta, int position) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¿Esta seguro de eliminar su perfil?'),
            actions: <Widget>[
              FlatButton(
                
                child: Text('Eliminar Perfil',
                style: TextStyle(
                  color: Colors.red,
                )
                ),
                onPressed: () =>
                    _deleteTerapeuta(context, items[position], position),
              ),

              FlatButton(
              
                child: Text('Cancelar',
                 style: TextStyle(
                  color: Colors.teal[500],
                )
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
//METODO PARA EDITAR EL PERFIL 
  Widget _update(BuildContext context, Terapeuta terapeuta, int position) {
    return FlatButton(
      color: Colors.orange,
      child: Container(
        child: Row(
          children: <Widget>[
            Text('Editar Perfil', textAlign: TextAlign.right, style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
     onPressed: () {
        _navigateToTerapeuta(context, items[position]);
      },
    );
  }
 //----------------------METODO PARA DEFINIR UNA PANTALLA A MOSTRAR SEGUN LA CONECTIVIDAD A INTERNET -------------------------------------------
  Widget buildStream(){
    return StreamBuilder(
      stream: terapeutaReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
          
          return  ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          },
        );
        
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
