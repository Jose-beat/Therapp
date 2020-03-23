import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';
import 'package:therapp/src/pages/Register/RegistrarAntcedentesPatologicos.dart';

class VerAntecPatologicos extends StatefulWidget {
  final String pacienteId;
  final AntecedentesPatologicos antecedentesPatologicos;
  VerAntecPatologicos({Key key, this.pacienteId, this.antecedentesPatologicos}) : super(key: key);

  @override
  _VerAntecPatologicosState createState() => _VerAntecPatologicosState();
}

class _VerAntecPatologicosState extends State<VerAntecPatologicos> {
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
                        _createNewAntecPatologico(context);
                      }, child: Text('Añadir Antecedentes Patologicos')
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

  void _createNewAntecPatologico(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResAntecedentesPatologicos(antecedentesPatologicos: AntecedentesPatologicos(null, '', widget.pacienteId),)));
 
  }
}