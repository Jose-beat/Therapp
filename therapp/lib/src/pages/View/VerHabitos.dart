import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Habitos.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';

class VerHabitos extends StatefulWidget {
  final Habitos habitos;
  final String pacienteId;
  VerHabitos({Key key, this.habitos, this.pacienteId}) : super(key: key);

  @override
  _VerHabitosState createState() => _VerHabitosState();
}
final habitosReference = FirebaseDatabase.instance.reference().child('habitos');
class _VerHabitosState extends State<VerHabitos> {
  List<Habitos>items;
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
                        _createNewHabitos(context);
                      }, child: Text('Añadir Habitos')
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


   void _createNewHabitos(BuildContext context) async {
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context)=> ResHabitos(habitos: Habitos(null,'','', widget.pacienteId),)));
    
  }
}