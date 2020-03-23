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
import 'package:therapp/src/pages/View/VerAntecedentesFamiliares.dart';
import 'package:therapp/src/pages/View/VerAntecedentesNoPatologicos.dart';
import 'package:therapp/src/pages/View/VerAntecedentesPatologicos.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerHabitos.dart';
import 'package:therapp/src/pages/View/verSignosVitales.dart';


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
    return DefaultTabController(
      length: 7,
          child: Scaffold(
        
        appBar: AppBar(
          title: Text('Ver Paciente'),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.ac_unit),),
            Tab(icon: Icon(Icons.ac_unit),),
            Tab(icon: Icon(Icons.ac_unit),),
            Tab(icon: Icon(Icons.ac_unit),),
            Tab(icon: Icon(Icons.ac_unit),),
            Tab(icon: Icon(Icons.ac_unit),),
            Tab(icon: Icon(Icons.ac_unit),),
          ]),
        ),
          body: TabBarView(
            children:<Widget>[

               ListView(
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
            

                    ],
                  ),
                ),
              ),
            ),
            ],
            
          ),
          VerSignosVitales(pacienteId: widget.paciente.id,),
          VerHabitos(pacienteId: widget.paciente.id,),
          VerConsultas(idPaciente: widget.paciente.id,),
          VerAntecPatologicos(pacienteId: widget.paciente.id,),
          VerAntecNoPatologico(pacienteId: widget.paciente.id,),
          VerAntecFamiliar(idPaciente: widget.paciente.id),

          ])
          
          
         
      ),
    );
  }


 
 


 

 
 
 

 
 


}