import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/pages/RegistrarSignosVitales.dart';

class VerPaciente extends StatefulWidget {
  final Paciente paciente;
  VerPaciente({Key key, this.paciente}) : super(key: key);

  @override
  _VerPacienteState createState() => _VerPacienteState();
}
final pacienteReference = FirebaseDatabase.instance.reference().child('paciente');

class _VerPacienteState extends State<VerPaciente> {
  List<Paciente> items;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Paciente'),
      ),
        body: Container(
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("${widget.paciente.nombre}"),
                  Divider(),
                  Text("${widget.paciente.apellidos}"),
                  Divider(),
                  Text("${widget.paciente.ocupacion}"),
                  Divider(),
                  Text("${widget.paciente.sexo}"),
                  Divider(),
                  Text("${widget.paciente.id}"),
                  Divider(),
                  FlatButton(
                    onPressed: (){
                    _createNewSignosVitales(context);
                  }, child: Text('Añadir Signos Vitales')
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

   void _createNewSignosVitales(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> RegistroSignosVitales(signosVitales: SignosVitales(null, '', '', '', '', widget.paciente.id),))
    );
  }
 


}