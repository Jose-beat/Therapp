import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/pages/View/NavigationBar.dart';
import 'package:therapp/src/pages/View/VerPaciente.dart';

class RegistrarPaciente extends StatefulWidget {
  final Paciente paciente;
  final String userId;
  RegistrarPaciente({Key key, this.paciente, this.userId}) : super(key: key);

  @override
  _RegistrarPacienteState createState() => _RegistrarPacienteState();
}

final pacienteReference =
    FirebaseDatabase.instance.reference().child('paciente');

class _RegistrarPacienteState extends State<RegistrarPaciente> {
  
   TextEditingController _inputFieldDateController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Paciente> items;

  TextEditingController _nombreController;
  TextEditingController _apellidosController;
  TextEditingController _edadController;
  TextEditingController _ocupacionController;
  TextEditingController _sexoController;
  String genero = 'Masculino';
  int edad = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nombreController = new TextEditingController(text: widget.paciente.nombre);
    _apellidosController =
        new TextEditingController(text: widget.paciente.apellidos);
    _edadController =
        new TextEditingController(text: widget.paciente.edad.toString());
    _ocupacionController =
        new TextEditingController(text: widget.paciente.ocupacion);
    _sexoController = new TextEditingController(text: widget.paciente.sexo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: _nombreController,
                          style:
                              TextStyle(fontSize: 17.0, color: Colors.deepPurple),
                          decoration: InputDecoration(
                              icon: Icon(Icons.ac_unit), labelText: 'nombre'),
                           validator: (value){
                              value=_nombreController.text;
                                    if(value.isEmpty){
                                      return 'Please enter some text';
                                    }else{
                 
                                        }},
                              ),
                      TextFormField(
                          controller: _apellidosController,
                          style:
                              TextStyle(fontSize: 17.0, color: Colors.deepPurple),
                          decoration: InputDecoration(
                              icon: Icon(Icons.ac_unit), labelText: 'apellidos'),
                          
                           validator: (value){
                              value=_apellidosController.text;
                                    if(value.isEmpty){
                                      return 'Please enter some text';
                                    }else{
                 
                                        }},
                              ),
                              _crearFecha(context),
                      TextFormField(
                          controller: _ocupacionController,
                          style:
                              TextStyle(fontSize: 17.0, color: Colors.deepPurple),
                          decoration: InputDecoration(
                              icon: Icon(Icons.ac_unit), labelText: 'ocupacion'),
                          
                           validator: (value){
                              value=_ocupacionController.text;
                                    if(value.isEmpty){
                                      return 'Please enter some text';
                                    }else{
                 
                                        }},

                              ),
                      edadOption(),
                      generoOption(),
                     // generoOption(),
                      FlatButton(
                          onPressed: () {
                             if(_formKey.currentState.validate()){

                                 if (widget.paciente.id != null) {
                              genero = widget.paciente.sexo;
                              pacienteReference.child(widget.paciente.id).set({
                                'nombre': _nombreController.text,
                                'apellidos': _apellidosController.text,
                                'nacimiento': _inputFieldDateController.text,
                                'edad': edad,
                                'ocupacion': _ocupacionController.text,
                                'sexo': genero,
                                'terapeuta': widget.userId
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              pacienteReference.push().set({
                                'nombre': _nombreController.text,
                                'apellidos': _apellidosController.text,
                                'nacimiento': _inputFieldDateController.text,
                                'edad': edad,
                                'ocupacion': _ocupacionController.text,
                                'sexo': genero,
                                'terapeuta': widget.userId
                              }).then((_) {
                               
                                final snackBar = SnackBar(
                                  content: Text('Paciente ${_nombreController.text} Registrado'),
                                
                                  );

                                Scaffold.of(context).showSnackBar(snackBar);
                              });
                            }


                             }
                          
                            print('${_nombreController.text}');
                          },
                          child: Text('Registrar Paciente'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget generoOption() {
    return DropdownButton<String>(
      value: genero,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          genero = newValue;
          newValue=_sexoController.text;
        });
      },
      items: <String>['Femenino', 'Masculino']
          .map<DropdownMenuItem<String>>((String value) {
        if (widget.paciente.id != null) {
          return DropdownMenuItem<String>(
              value: value,
              child: Text(value)
              );

        } else {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }
      }).toList(),
    );
  }




  Widget edadOption() {
    return DropdownButton<int>(
      value: edad,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int newValue) {
        setState(() {
          edad = newValue;
         
        });
      },
      items: edades().map<DropdownMenuItem<int>>((dynamic value) {
        if (widget.paciente.id != null) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        } else {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }
      }).toList(),
    );
  }

  List edades() {
    List<int> edades = [];

    for (var i = 0; i < 100; i++) {
      edades.add(i);
      print(i);
    }
    return edades;
  }


  

Widget _crearFecha(BuildContext context){

    return TextFormField(
       validator: (value){
                              value=_inputFieldDateController.text;
                            if(value.isEmpty){
                              return 'Favor de añadir la fecha';
                            }
                             },
      //Pasamos la fecha por aqui
      controller: _inputFieldDateController,
      //Desactivamos la accion interactiva
      enableInteractiveSelection: false,
     //Añadir estilo a la caja de texto
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        
        //Sera un texto original en la caja
        hintText: 'Fecha de nacimiento',
        //Sera el titulo de nuestra caja
        labelText: 'Fecha de nacimiento',
        suffixIcon: Icon(Icons.calendar_today),
        icon: Icon(Icons.calendar_view_day),  
        ),
   
         
      
        onTap: (){
          //Quitar el foco que significa que el teclado no se activara
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDay(context);
        },
    );



}


  //Si un metodo recibe un future entonces hay que añadirle el asyn y await
  //donde corresponda
  _selectDay(BuildContext context) async {
    
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),
     //Cambiar el idioma del cuadro de fechas
     //mOSTRARA UN ERROR DE FORMA NORMAL SI NO EXISTE UNA DEPENDENCIA
     // locale: Locale('fr','CH'),

    );
    //Con esta condicional vamos a meter la informacion de la fecha en el cuadro de texto
  
    if (picked != null){
      setState(() {
        String _fecha = "${picked.day} / ${picked.month} / ${picked.year}";
        _inputFieldDateController.text = _fecha;
      });
    }

  }




}
