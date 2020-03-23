import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/AntecedentesFamilia.dart';
import 'package:therapp/src/models/AntecedentesNoPatologicos.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';
import 'package:therapp/src/models/Habitos.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarAntcedentesPatologicos.dart';
import 'package:therapp/src/pages/Register/RegistrarAntecedentesFamiliares.dart';
import 'package:therapp/src/pages/Register/RegistrarAntecedentesNoPatologicos.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';
import 'package:therapp/src/pages/Register/RegistrarSignosVitales.dart';


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
        body: ListView(
          children: <Widget>[
            Container(
            child: Card(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("${widget.paciente.nombre}"),
                    Divider(),
                    Text("${widget.paciente.apellidos}"),
                    Divider(),
                    Text("${widget.paciente.edad}"),
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
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: (){
                      _createNewHabitos(context);
                    }, child: Text('Añadir Habitos')
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: (){
                      _createNewConsultas(context);
                    }, child: Text('Añadir Consultas')
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: (){
                      _createNewAntecPatologico(context);
                    }, child: Text('Añadir Antecedentes Patologicos')
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: (){
                      _createNewAntecNoPatologico(context);
                    }, child: Text('Añadir Antecedentes No Patologicos')
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: (){
                      _createNewAntecFamiliar(context);
                    }, child: Text('Añadir Antecedentes Familiares')
                    ),
                    Divider()

                  ],
                ),
              ),
            ),
          ),
          ],
          
        ),
    );
  }

   void _createNewSignosVitales(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> RegistroSignosVitales(signosVitales: SignosVitales(null,'' , '', 0.0, '', widget.paciente.id),))
    );
  }

  void _createNewHabitos(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResHabitos(habitos: Habitos(null,'','', widget.paciente.id),)));
    
  }
 

 void _createNewConsultas(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResConsultas(consultas: Consultas(null,'', widget.paciente.id),)));
    
  }
 
 void _createNewAntecNoPatologico(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResAntecedentesNoPatologicos(antecedentesNoPatologicos: AntecedentesNoPatologicos(null,'', widget.paciente.id),)));
 
  }
 
 void _createNewAntecPatologico(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResAntecedentesPatologicos(antecedentesPatologicos: AntecedentesPatologicos(null, '', widget.paciente.id),)));
 
  }
 
 void _createNewAntecFamiliar(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResAntecedentesFamiliares(antecedentesFamiliares: AntecedentesFamiliares(null,false,false,false, widget.paciente.id),)));
  }
 
 


}