import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';


/*METODO PARA REGISTRAR LOS ANTECEDENTES PATOLOGICOS DEL PACIENTE */
class ResAntecedentesPatologicos extends StatefulWidget {
  final AntecedentesPatologicos antecedentesPatologicos;

  ResAntecedentesPatologicos({Key key, this.antecedentesPatologicos})
      : super(key: key);

  @override
  _ResAntecedentesPatologicosState createState() =>
      _ResAntecedentesPatologicosState();
}
//METODO DE BASE DE DATOS 
final antecedentesPatologicosReference =
    FirebaseDatabase.instance.reference().child('antecedentes_patologicos');

class _ResAntecedentesPatologicosState
    extends State<ResAntecedentesPatologicos> {

      final _formKey = GlobalKey<FormState>();
  List<AntecedentesPatologicos> items;

  TextEditingController _enfermedadController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _enfermedadController = new TextEditingController(
        text: widget.antecedentesPatologicos.enfermedad);
  }
//METODO PARA DIBUJAR LA PANTALLA 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[500],
          title: Text('Antecedentes Patologicos')
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
                          maxLines: 1,
                          controller: _enfermedadController,
                          style: TextStyle(fontSize: 17.0),
                          decoration: decoracion('Enfermedad', Icons.accessibility_new),


                                validator: (value){
                                value=_enfermedadController.text;
                              if(value.isEmpty){
                                return 'Favor de añadir la fecha';
                              }
                               },
                        ),

                        //METODO PARA EL REGISTRO DE CADA DATOS 
                        FlatButton(
                          color: Colors.orange,
                            onPressed: () {

                              if(_formKey.currentState.validate()){
                              if (widget.antecedentesPatologicos.id != null) {
                                antecedentesPatologicosReference
                                    .child(widget.antecedentesPatologicos.id)
                                    .set({
                                  'enfermedad': _enfermedadController.text,
                                  'paciente':
                                      widget.antecedentesPatologicos.idpaciente
                                }).then((_) {
                                  Navigator.pop(context);
                                });
                              } else {
                                antecedentesPatologicosReference.push().set({
                                  'enfermedad': _enfermedadController.text,
                                  'paciente':
                                      widget.antecedentesPatologicos.idpaciente
                                }).then((_) {
                                  Navigator.pop(context);
                                });
                              }}
                            },
                            child: Text('Añadir Antecedente patologico',
                             style: TextStyle(
                            color: Colors.white
                          ),
                            ),
                            
                            )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
//METODO DE FORMATO DE FORMULARIO 
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
