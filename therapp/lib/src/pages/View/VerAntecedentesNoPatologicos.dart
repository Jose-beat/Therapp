import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesNoPatologicos.dart';
import 'package:therapp/src/pages/Register/RegistrarAntecedentesNoPatologicos.dart';

class VerAntecNoPatologico extends StatefulWidget {
  final String pacienteId;
  final AntecedentesNoPatologicos antecedentesNoPatologicos;
  VerAntecNoPatologico({Key key, this.pacienteId, this.antecedentesNoPatologicos}) : super(key: key);

  @override
  _VerAntecNoPatologicoState createState() => _VerAntecNoPatologicoState();
}

class _VerAntecNoPatologicoState extends State<VerAntecNoPatologico> {
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
                        _createNewAntecNoPatologico(context);
                      }, child: Text('Añadir Antecedentes No Patologicos')
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


   void _createNewAntecNoPatologico(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResAntecedentesNoPatologicos(antecedentesNoPatologicos: AntecedentesNoPatologicos(null,'', widget.pacienteId),)));
 
  }
}