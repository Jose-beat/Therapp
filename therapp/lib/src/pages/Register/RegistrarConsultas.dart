import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/consultas.dart';

class ResConsultas extends StatefulWidget {
  final Consultas consultas;

  ResConsultas({Key key, this.consultas}) : super(key: key);

  @override
  _ResConsultasState createState() => _ResConsultasState();
}

final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _ResConsultasState extends State<ResConsultas> {
  List<Consultas> items;

  TextEditingController _motivoController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _motivoController =
        new TextEditingController(text: widget.consultas.motivos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: <Widget>[
            Container(
              child: Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _motivoController,
                        style: TextStyle(fontSize: 17.0, color: Colors.orange),
                        decoration: InputDecoration(
                            icon: Icon(Icons.event_note),
                            labelText: 'Motivo de consukta'),
                      ),
                      FlatButton(
                          onPressed: () {
                            if (widget.consultas.id != null) {
                              consultasReference
                                  .child(widget.consultas.id)
                                  .set({
                                'motivos_consulta': _motivoController.text,
                                'paciente': widget.consultas.idPaciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              consultasReference.push().set({
                                'motivos_consulta': _motivoController.text,
                                'paciente': widget.consultas.idPaciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text('Añadir Consulta'))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
