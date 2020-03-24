import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesFamilia.dart';
import 'package:therapp/src/pages/Register/RegistrarAntecedentesFamiliares.dart';

class VerAntecFamiliar extends StatefulWidget {
  final AntecedentesFamiliares antecedentesFamiliares;
  final String idPaciente;
  VerAntecFamiliar({Key key, this.antecedentesFamiliares, this.idPaciente})
      : super(key: key);

  @override
  _VerAntecFamiliarState createState() => _VerAntecFamiliarState();
}

final antecFamiliReference =
    FirebaseDatabase.instance.reference().child('antecedentes_no_patologicos');

class _VerAntecFamiliarState extends State<VerAntecFamiliar> {
  StreamSubscription<Event> _onAntFamiliaAddedSubscription;
  StreamSubscription<Event> _onAntFamiliaChangedSubscription;
  List<AntecedentesFamiliares> items;
  @override
  void initState() {
    super.initState();
    items = new List();
    _onAntFamiliaAddedSubscription =
        antecFamiliReference.onChildAdded.listen(_onAntFamiliaAdded);
    _onAntFamiliaChangedSubscription =
        antecFamiliReference.onChildChanged.listen(_onAntFamiliaUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onAntFamiliaAddedSubscription.cancel();
    _onAntFamiliaChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, position) {
              return _filter(context, position);
            }));
  }

  void _onAntFamiliaAdded(Event event) {
    setState(() {
      items.add(new AntecedentesFamiliares.fromSnapshot(event.snapshot));
    });
  }

  void _onAntFamiliaUpdate(Event event) {
    var oldAntFamiliaValue = items.singleWhere((antecedentesFamiliares) =>
        antecedentesFamiliares.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldAntFamiliaValue)] =
          new AntecedentesFamiliares.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToAntFamilia(BuildContext context,
      AntecedentesFamiliares antecedentesFamiliares) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResAntecedentesFamiliares(
                antecedentesFamiliares: antecedentesFamiliares,
              )),
    );
  }

  void _createNewAntecFamiliar(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResAntecedentesFamiliares(
                  antecedentesFamiliares: AntecedentesFamiliares(
                      null, false, false, false, widget.idPaciente),
                )));
  }

  Widget _filter(BuildContext context, int position) {
    if (items[position].idpaciente == widget.idPaciente) {
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
          _lista(items[position].cancer.toString(), context, position),
          Divider(),
          _lista(items[position].diabetes.toString(), context, position),
          Divider(),
          _lista(items[position].hipertension.toString(), context, position),
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
              onPressed: () => _navigateToAntFamilia(context, items[position]))
        ],
      ),
    );
  }
}
