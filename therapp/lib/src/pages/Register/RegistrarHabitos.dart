import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/Habitos.dart';

class ResHabitos extends StatefulWidget {
  final Habitos habitos;
 
  ResHabitos({Key key, this.habitos}) : super(key: key);

  @override
  _ResHabitosState createState() => _ResHabitosState();
}
final habitosReference = FirebaseDatabase.instance.reference().child('habitos');
class _ResHabitosState extends State<ResHabitos> {
  List<Habitos>items;
  TextEditingController _habitoAlimenticioController;
  TextEditingController _habitoHigieneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _habitoAlimenticioController = new TextEditingController(text: widget.habitos.habitosAlimenticios);
    _habitoHigieneController = new TextEditingController(text: widget.habitos.habitosHigiene);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: Center(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _habitoAlimenticioController,
                      style: TextStyle(fontSize: 17.0, color: Colors.green),
                      decoration: InputDecoration(icon: Icon(Icons.fastfood),
                      labelText: 'Habitos ALimenticios'
                      ),
                    ),
                    TextFormField(
                      controller: _habitoHigieneController,
                      style: TextStyle(fontSize: 17.0, color: Colors.green),
                      decoration: InputDecoration(icon: Icon(Icons.fastfood),
                      labelText: 'Habitos ALimenticios'
                      ),
                    ),

                    FlatButton(onPressed: (){
                      if(widget.habitos.id!=null){
                        habitosReference.child(widget.habitos.id).set({
                          'habitos_Alimenticios':_habitoAlimenticioController.text,
                          'habitos_higiene':_habitoHigieneController.text,
                          'paciente':widget.habitos.paciente
                        }).then((_){
                          Navigator.pop(context);
                        });
                      }else{
                        habitosReference.push().set({
                          'habitos_Alimenticios':_habitoAlimenticioController.text,
                          'habitos_higiene':_habitoHigieneController.text,
                          'paciente':widget.habitos.paciente

                        }).then((_){
                          Navigator.pop(context);
                        });
                      }

                    },  
                    
                    child: Text('Subir'))
                    
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}