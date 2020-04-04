import 'dart:async';
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
  List<Paciente> items;

  StreamSubscription<Event> _onPacienteAddedSubscription;
  StreamSubscription<Event> _onPacienteupdatedSubscription;

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
      
     
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, position) {
          return _filter(context, position);
        },
      ),

      
    );
  }

/*---------------------------METODOS PARA CREAR AL PÁCIENTE */

 
  void _navigateToPaciente(BuildContext context, Paciente paciente, String idTerapeuta) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerPaciente(paciente: paciente,idTerapeuta: idTerapeuta,)));
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
                )));
  }
/*-------------------------------------METODOS TERAPEUTA--------------------------*/

  

  Widget _filter(BuildContext context, int position) {
    print("item :${items[position].id}");

    if (items[position].terapeuta == widget.userId) {
      print('${items[position].id}');

      return Column(
        children: <Widget>[
          Divider(
            height: 7.0,
          ),
          Card(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: ListTile(
                  title: Text(
                    '${items[position].nombre}',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 21.0),
                  ),
                  subtitle: Text(
                    '${items[position].apellidos}',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 21.0,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 17.0,
                        child: '${items[position].imagenPaciente}'== ''
                        ? Text('No hay imagen'):
                        Image.network('${items[position].imagenPaciente}' + '?alt=media',
                          fit: BoxFit.fill,
                        )
                      )
                    ],
                  ),
                  onTap: () => _navigateToPaciente(context, items[position],widget.userId),
                )),
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.red,
                    ),
                    onPressed: () =>
                        _changePacienteInformation(context, items[position]))
              ],
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }
}
