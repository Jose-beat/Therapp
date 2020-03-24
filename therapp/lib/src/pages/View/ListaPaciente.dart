import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/Terapeuta.dart';

class ListaPacientes extends StatefulWidget {
  final Paciente paciente;
  ListaPacientes({Key key, this.paciente}) : super(key: key);

  @override
  _ListaPacientesState createState() => _ListaPacientesState();
}

final pacienteReference =
    FirebaseDatabase.instance.reference().child('pacientes');

class _ListaPacientesState extends State<ListaPacientes> {
  List<Paciente> items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kjsbdjkdz',
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('sdvkjds'),
              floating: true,
              flexibleSpace: Placeholder(),
              expandedHeight: 200,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                  title: Text('${widget.paciente.id}'),
                  onTap: () {},
                ),
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
