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
  final _formKey = GlobalKey<FormState>();
  List<Habitos> items;
  TextEditingController _habitoAlimenticioController;
  TextEditingController _habitoHigieneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _habitoAlimenticioController =
        new TextEditingController(text: widget.habitos.habitosAlimenticios);
    _habitoHigieneController =
        new TextEditingController(text: widget.habitos.habitosHigiene);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Habitos'),
        backgroundColor: Colors.teal[500],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: Center(
                child: Form(
                  key: _formKey,
                                  child: Column(
                    children: <Widget>[
                      Divider(),
                      TextFormField(
                        controller: _habitoAlimenticioController,
                        style: TextStyle(fontSize: 17.0, color: Colors.green),
                        decoration: decoracion('Habitos alimenticios',Icons.favorite_border),
                        validator: (value){
                              value=_habitoAlimenticioController.text;
                            if(value.isEmpty){
                              return 'Favor de añadir la fecha';
                            }
                             },
                      ),
                      Divider(),
                      TextFormField(
                        controller: _habitoHigieneController,
                        style: TextStyle(fontSize: 17.0, color: Colors.green),
                        decoration: decoracion('Habitos de higene',Icons.drag_handle),
                        validator: (value){
                              value=_habitoHigieneController.text;
                            if(value.isEmpty){
                              return 'Favor de añadir la fecha';
                            }
                             },
                      ),
                      FlatButton(
                         color: Colors.orange,
                          onPressed: () {
                            if(_formKey.currentState.validate()){
                            if (widget.habitos.id != null) {
                              habitosReference.child(widget.habitos.id).set({
                                'habitos_alimenticios':
                                    _habitoAlimenticioController.text,
                                'habitos_higiene': _habitoHigieneController.text,
                                'paciente': widget.habitos.paciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              habitosReference.push().set({
                                'habitos_alimenticios':
                                    _habitoAlimenticioController.text,
                                'habitos_higiene': _habitoHigieneController.text,
                                'paciente': widget.habitos.paciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            }
                            }
                          },
                          child: Text('Subir',
                          style: TextStyle(
                            color: Colors.white
                          ),
                          ),
                          
                          ),
                          
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  
InputDecoration decoracion(String nombre, IconData icono){
  return InputDecoration(
    
    border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: nombre,
            prefixIcon: new Icon(
              icono,
              color: Colors.grey,
            ));
}

}
