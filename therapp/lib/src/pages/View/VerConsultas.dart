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

class _VerConsultasState extends State<VerConsultas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
            
            children: <Widget>[
              Container(
                child: Card(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('MUESTRA HABITOS'),
                        FlatButton(
                        onPressed: (){
                        _createNewConsultas(context);
                      }, child: Text('Añadir Consultas')
                      ),
                      ],
                    
                    ),
                  ),
                ),
              )
            ],
      ),
    );
  }


   void _createNewConsultas(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResConsultas(consultas: Consultas(null,'', widget.idPaciente),)));
    
  }
}