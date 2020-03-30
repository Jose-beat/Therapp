import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Habitos.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';

class VerHabitos extends StatefulWidget {
  final Habitos habitos;
  final String pacienteId;
  VerHabitos({Key key, this.habitos, this.pacienteId}) : super(key: key);

  @override
  _VerHabitosState createState() => _VerHabitosState();
}

final habitosReference = FirebaseDatabase.instance.reference().child('habitos');

class _VerHabitosState extends State<VerHabitos> {
  List<Habitos> items;
  StreamSubscription<Event> _onHabitosAddedSubscription;
  StreamSubscription<Event> _onHabitosChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onHabitosAddedSubscription =
        habitosReference.onChildAdded.listen(_onHabitosAdded);
    _onHabitosChangedSubscription =
        habitosReference.onChildChanged.listen(_onHabitosUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _onHabitosAddedSubscription.cancel();
    _onHabitosChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, position) {
              return _filter(context, position);
            }),
            floatingActionButton: FloatingActionButton(onPressed: ()=>_createNewHabitos(context)),
            );
  }

/*------------------------------------BACKEND----------------------------------------*/
  void _onHabitosAdded(Event event) {
    setState(() {
      items.add(new Habitos.fromSnapshot(event.snapshot));
    });
  }

  void _onHabitosUpdate(Event event) {
    var oldHabitosValue =
        items.singleWhere((habitos) => habitos.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldHabitosValue)] =
          new Habitos.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToHabitos(BuildContext context, Habitos habitos) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResHabitos(
            habitos: habitos
          )
        ));
  }

  void _createNewHabitos(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResHabitos(
                  habitos: Habitos(null, '', '', widget.pacienteId),
                )));
  }

  /*-----FRONTEDN-----*/

  Widget _filter(BuildContext context, int position) {
    if (items[position].paciente == widget.pacienteId) {
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
          _lista(items[position].habitosAlimenticios, context, position,'Habito Alimenticio'),
          Divider(),
          _lista(items[position].habitosHigiene, context, position,'Habito de Higiene'),
        ],
      ),
    );
  }

  Widget _lista(String variable, BuildContext context, int position,String subtitulo) {
    return ListTile(

      title: Text('$variable',style: Theme.of(context).textTheme.headline,),
      subtitle: Text('$subtitulo'),

      onTap: () => _navigateToHabitos(context, items[position]),
     /* 
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$variable'),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToHabitos(context, items[position]))
        ],
      ),*/
    );
  }
}
