import 'package:flutter/material.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/pages/Register/RegistrarSignosVitales.dart';

class VerSignosVitales extends StatefulWidget {
  final SignosVitales signosVitales;
  final String pacienteId;
  VerSignosVitales({Key key, this.signosVitales, this.pacienteId}) : super(key: key);

  @override
  _VerSignosVitalesState createState() => _VerSignosVitalesState();
}

class _VerSignosVitalesState extends State<VerSignosVitales> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView(
            
            children: <Widget>[
              Container(
                child: Card(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('MUESTRA SINGNOS VITALES'),
                         FlatButton(
                        onPressed: (){
                        _createNewSignosVitales(context);
                      }, child: Text('Añadir Signos Vitales')
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
  
   void _createNewSignosVitales(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> RegistroSignosVitales(signosVitales: SignosVitales(null,'' , '', 0.0, '', widget.pacienteId),))
    );
  }
}