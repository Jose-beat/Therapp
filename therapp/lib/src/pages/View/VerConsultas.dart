import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';

class VerConsultas extends StatefulWidget {
  final String idPaciente;
  final Consultas consultas;
  VerConsultas({Key key, this.idPaciente, this.consultas}) : super(key: key);

  @override
  _VerConsultasState createState() => _VerConsultasState();
}

final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _VerConsultasState extends State<VerConsultas> {
  StreamSubscription<Event> _onConsultaAddedSubscription;
  StreamSubscription<Event> _onConsultaChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onConsultaAddedSubscription =
        consultasReference.onChildAdded.listen(_onConsultasAdded);
    _onConsultaChangedSubscription =
        consultasReference.onChildChanged.listen(_onConsultasUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _onConsultaAddedSubscription.cancel();
    _onConsultaChangedSubscription.cancel();
  }

  List<Consultas> items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, position) {
              return _filter(context, position);
            }));
  }

  /*------------------------------------BACKEND----------------------------------------*/
  void _onConsultasAdded(Event event) {
    setState(() {
      items.add(new Consultas.fromSnapshot(event.snapshot));
    });
  }

  void _onConsultasUpdate(Event event) {
    var oldConsultasValue =
        items.singleWhere((consultas) => consultas.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldConsultasValue)] =
          new Consultas.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToConsultas(BuildContext context, Consultas consultas) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResConsultas(
            consultas: consultas,
          ),
        ));
  }

  void _createNewConsultas(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResConsultas(
                  consultas: Consultas(null, '', widget.idPaciente),
                )));
  }

  Widget _filter(BuildContext context, int position) {
    print('VE ESTE MENSAJE');

    if (items[position].idPaciente == widget.idPaciente) {
      print('WE NO MAMES ESTA ES LA ID DE LA CONSULTA ${items[position].id}');
      print('MOTIVOS ${items[position].motivos}');
      print('PACIENTE: ${items[position].idPaciente} ${widget.idPaciente}');

      return Column(
        children: <Widget>[_info(context, position)],
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
          Divider(),
          _lista(items[position].motivos, context, position),
        ],
      ),
    );
  }

  Widget _lista(String variable, BuildContext context, int position) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$variable'),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToConsultas(context, items[position]))
        ],
      ),
    );
  }
}
