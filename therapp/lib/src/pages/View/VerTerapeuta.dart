import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Terapeuta.dart';
import 'package:therapp/src/pages/Register/RegistroPerfil.dart';
import 'package:therapp/src/providers/authentApp.dart';

class VerTerapeuta extends StatefulWidget {
  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  VerTerapeuta({Key key, this.userId, this.auth, this.logoutCallback})
      : super(key: key);

  @override
  _VerTerapeutaState createState() => _VerTerapeutaState();
}

final terapeutaReference =
    FirebaseDatabase.instance.reference().child('terapeuta');

class _VerTerapeutaState extends State<VerTerapeuta> {
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
  @override
  void initState() {
    super.initState();
    items = new List();
    _onTerapeutaAddedSubscription =
        terapeutaReference.onChildAdded.listen(_onTerapeutaAdded);
    _onTerapeutaChangedSubscription =
        terapeutaReference.onChildChanged.listen(_onTerapeutaUpdated);
        
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onTerapeutaAddedSubscription.cancel();
    _onTerapeutaChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          },
        ));
  }

/*-------------------------------------------------------BACKEND--------------------------------------- */

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
      });
    });
  }

  void _navigateToTerapeuta(BuildContext context, Terapeuta terapeuta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistroPerfil(
                terapeuta: terapeuta,
                email: terapeuta.email,
              )),
    );
  }

/*-------------------------------------FRONTEND-----------------------------*/

  Widget _filter(BuildContext context, int position) {
    print("Usuario Actual :${items[position].id}");
    print("USER ID: ${widget.userId}");

    if (items[position].id == widget.userId) {
      print('${items[position].id}');

      return Column(
        children: <Widget>[
          CircleAvatar(
            radius: 70.0,
            child: items[position].imagen == '' ? 
            Text('No hay imagen aun') :
            Image.network(items[position].imagen + '?alt=media')
          ),
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
          _lista('Fecha de Nacimiento', items[position].nacimiento, context, position),
          Divider(),
          _lista('Correo Electronico', items[position].email, context, position),
          Divider(),
          _lista('Clinica',items[position].clinica, context, position),
          Divider(),
           _lista('Cedula Profesional',items[position].cedula, context, position),
          Divider(),
          _lista('Especialidad',items[position].especialidad, context, position),
          
          Divider(),
          _lista('N.Telefonico',items[position].telefono, context, position),
          _update(context, items[position], position),
          _delete(context, items[position], position)
        ],
      ),
    );
  }

  Widget _lista(String tipo, String variable, BuildContext context, int position) {
    return ListTile(
      subtitle: Text('$tipo'),
          title: Text('$variable'),
         /* IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToTerapeuta(context, items[position]))*/
      
    
    );
  }

  Widget _delete(BuildContext context, Terapeuta terapeuta, int position) {
    return ListTile(
      
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Container(

        child: Row(
          children: <Widget>[
            Text('Eliminar Perfil', textAlign: TextAlign.right),
          ],
        ),
      ),
      onTap: () {
        _deleteTerapeuta(context, items[position], position);
        widget.auth.deleteUser();
        return signOut;
      },
    );
  }



    Widget _update(BuildContext context, Terapeuta terapeuta, int position) {
    return ListTile(
      
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Container(

        child: Row(
          children: <Widget>[
            Text('Editar Perfil', textAlign: TextAlign.right),
          ],
        ),
      ),
      onTap: () {
        _navigateToTerapeuta(context, items[position]);
        
      },
    );
  }
}

