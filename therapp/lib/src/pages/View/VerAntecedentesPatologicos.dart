import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';

import 'package:therapp/src/pages/Register/RegistrarAntcedentesPatologicos.dart';

class VerAntecPatologicos extends StatefulWidget {
  final String pacienteId;
  final AntecedentesPatologicos antecedentesPatologicos;
  VerAntecPatologicos({Key key, this.pacienteId, this.antecedentesPatologicos})
      : super(key: key);

  @override
  _VerAntecPatologicosState createState() => _VerAntecPatologicosState();
}

final antecPatReference =
    FirebaseDatabase.instance.reference().child('antecedentes_patologicos');

class _VerAntecPatologicosState extends State<VerAntecPatologicos> {
  StreamSubscription<Event> _onAntPatAddedSubscription;
  StreamSubscription<Event> _onAntPatChangedSubscription;
  List<AntecedentesPatologicos> items;
  @override
  void initState() {
    super.initState();
    items = new List();
    _onAntPatAddedSubscription =
        antecPatReference.onChildAdded.listen(_onAntPatAdded);
    _onAntPatChangedSubscription =
        antecPatReference.onChildChanged.listen(_onAntPatUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onAntPatAddedSubscription.cancel();
    _onAntPatChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewAntecPatologico(context)),
    );
  }

  /*------------------------------------BACKEND----------------------------------------*/
  void _onAntPatAdded(Event event) {
    setState(() {
      items.add(new AntecedentesPatologicos.fromSnapshot(event.snapshot));
    });
  }

  void _onAntPatUpdate(Event event) {
    var oldAntPatValue = items.singleWhere((antecedentesPatologicos) =>
        antecedentesPatologicos.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldAntPatValue)] =
          new AntecedentesPatologicos.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToAntPat(BuildContext context,
      AntecedentesPatologicos antecedentesPatologicos) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResAntecedentesPatologicos(
                antecedentesPatologicos: antecedentesPatologicos,
              )),
    );
  }

  void _createNewAntecPatologico(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResAntecedentesPatologicos(
                  antecedentesPatologicos:
                      AntecedentesPatologicos(null, '', widget.pacienteId),
                )));
  }

  Widget _filter(BuildContext context, int position) {
    if (items[position].idpaciente == widget.pacienteId) {
      print('WE NO MAMES ESTA ES LA ID DE LA CONSULTA ${items[position].id}');
      print('MOTIVOS PATOLOGICOS ${items[position].enfermedad}');
      print('PACIENTE: ${items[position].idpaciente} ${widget.pacienteId}');

      print('${items[position].id}');

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
          _lista(items[position].enfermedad, context, position,
              'Antecedente Patologico'),
        ],
      ),
    );
  }

  Widget _lista(
      String variable, BuildContext context, int position, String subtitulo) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$variable', style: Theme.of(context).textTheme.headline),
          VerticalDivider(
            width: 110.0,
          ),
          VerticalDivider(
            width: 110.0,
          ),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToAntPat(context, items[position]))
        ],
      ),
      subtitle: Text('$subtitulo'),
    );
  }
}
