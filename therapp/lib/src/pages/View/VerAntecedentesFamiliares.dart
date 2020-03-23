import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesFamilia.dart';
import 'package:therapp/src/pages/Register/RegistrarAntecedentesFamiliares.dart';

class VerAntecFamiliar extends StatefulWidget {
  final AntecedentesFamiliares antecedentesFamiliares;
  final String idPaciente;
  VerAntecFamiliar({Key key, this.antecedentesFamiliares, this.idPaciente}) : super(key: key);

  @override
  _VerAntecFamiliarState createState() => _VerAntecFamiliarState();
}

class _VerAntecFamiliarState extends State<VerAntecFamiliar> {
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
                        _createNewAntecFamiliar(context);
                      }, child: Text('Añadir Antecedentes Familiares')
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

   void _createNewAntecFamiliar(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResAntecedentesFamiliares(antecedentesFamiliares: AntecedentesFamiliares(null,false,false,false, widget.idPaciente),)));
  }
}