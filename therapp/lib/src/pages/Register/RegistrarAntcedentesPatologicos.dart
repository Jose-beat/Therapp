import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';

class ResAntecedentesPatologicos extends StatefulWidget {
  final AntecedentesPatologicos antecedentesPatologicos;

  ResAntecedentesPatologicos({Key key, this.antecedentesPatologicos})
      : super(key: key);

  @override
  _ResAntecedentesPatologicosState createState() =>
      _ResAntecedentesPatologicosState();
}

final antecedentesPatologicosReference =
    FirebaseDatabase.instance.reference().child('antecedentes_patologicos');

class _ResAntecedentesPatologicosState
    extends State<ResAntecedentesPatologicos> {
  List<AntecedentesPatologicos> items;

  TextEditingController _enfermedadController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _enfermedadController = new TextEditingController(
        text: widget.antecedentesPatologicos.enfermedad);
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
                        controller: _enfermedadController,
                        style: TextStyle(fontSize: 17.0, color: Colors.pink),
                        decoration: InputDecoration(
                            icon: Icon(Icons.archive), labelText: 'Enfermedad'),
                      ),
                      FlatButton(
                          onPressed: () {
                            if (widget.antecedentesPatologicos.id != null) {
                              antecedentesPatologicosReference
                                  .child(widget.antecedentesPatologicos.id)
                                  .set({
                                'enfermedad': _enfermedadController.text,
                                'paciente':
                                    widget.antecedentesPatologicos.idpaciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              antecedentesPatologicosReference.push().set({
                                'enfermedad': _enfermedadController.text,
                                'paciente':
                                    widget.antecedentesPatologicos.idpaciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text('Añadir Antecedente patologico'))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
