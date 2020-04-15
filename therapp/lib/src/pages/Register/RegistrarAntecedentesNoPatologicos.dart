import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesNoPatologicos.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';
/*METODO PARA REGISTRAR ANTECEDENTE PATOLOGICO*/
class ResAntecedentesNoPatologicos extends StatefulWidget {

  
  final AntecedentesNoPatologicos antecedentesNoPatologicos;

  ResAntecedentesNoPatologicos({Key key, this.antecedentesNoPatologicos})
      : super(key: key);

  @override
  _ResAntecedentesNoPatologicosState createState() =>
      _ResAntecedentesNoPatologicosState();
}
//METODO DE BD
final antecedentesNoPatologicosReference =
    FirebaseDatabase.instance.reference().child('antecedentes_no_patologicos');


class _ResAntecedentesNoPatologicosState
    extends State<ResAntecedentesNoPatologicos> {
      final _formKey = GlobalKey<FormState>();
  List<AntecedentesNoPatologicos> items;

  TextEditingController _enfermedadController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _enfermedadController = new TextEditingController(
        text: widget.antecedentesNoPatologicos.enfermedad);
  }
//METODO PARA DIBUJAR PANTALLA 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         backgroundColor:  Colors.teal[500],
         title: Text('Antecedentes No Patologicos'),
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
                          controller: _enfermedadController,
                          style: TextStyle(fontSize: 17.0, color: Colors.pink),
                          decoration: decoracion('Enfermedad',Icons.accessibility_new),
                             validator: (value){
                              value=_enfermedadController.text;
                            if(value.isEmpty){
                              return 'Favor de añadir la fecha';
                            }
                             },
                        ),

                        Divider(),

                        FlatButton(
                          color: Colors.orange,
                            onPressed: () {
                              //METODO PARA ENVIAR DATOS A LA PLATAFORMA 
                              if(_formKey.currentState.validate()){
                              if (widget.antecedentesNoPatologicos.id != null) {
                                antecedentesNoPatologicosReference
                                    .child(widget.antecedentesNoPatologicos.id)
                                    .set({
                                  'enfermedad': _enfermedadController.text,
                                  'paciente':
                                      widget.antecedentesNoPatologicos.idpaciente
                                }).then((_) {
                                  Navigator.pop(context);
                                });
                              } else {
                                antecedentesNoPatologicosReference.push().set({
                                  'enfermedad': _enfermedadController.text,
                                  'paciente':
                                      widget.antecedentesNoPatologicos.idpaciente
                                }).then((_) {
                                  Navigator.pop(context);
                                });
                              }
                              }
                            },
                            child: Text('Añadir Antecedente No patologico',
                            style: TextStyle(
                              color: Colors.white
                            ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
//METODO PARA FORMATO DE FORMULARIO 
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
