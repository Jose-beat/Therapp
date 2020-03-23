import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:firebase_database/firebase_database.dart';



class RegistrarPaciente extends StatefulWidget {
  final Paciente paciente;
  final String userId;
  RegistrarPaciente({Key key, this.paciente, this.userId}) : super(key: key);

  @override
  _RegistrarPacienteState createState() => _RegistrarPacienteState();
}
final pacienteReference = FirebaseDatabase.instance.reference().child('paciente');


class _RegistrarPacienteState extends State<RegistrarPaciente> {
  
  List<Paciente>items;

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
    _nombreController = new TextEditingController(text:widget.paciente.nombre);
    _apellidosController = new TextEditingController(text:widget.paciente.apellidos);
    _edadController = new   TextEditingController(text: widget.paciente.edad.toString());
    _ocupacionController = new TextEditingController(text:widget.paciente.ocupacion);
    _sexoController = new TextEditingController(text:widget.paciente.sexo);
  }
  @override
  Widget build(BuildContext context) {
   
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Paciente'),
      ),

      body: ListView(
        children: <Widget>[
           Container(
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nombreController,
                    style: TextStyle( fontSize: 17.0, color: Colors.deepPurple),
                    decoration: InputDecoration(icon: Icon(Icons.ac_unit),
                    labelText: 'nombre')),
                  
                  TextFormField(
                    controller: _apellidosController,
                    style: TextStyle( fontSize: 17.0, color: Colors.deepPurple),
                    decoration: InputDecoration(icon: Icon(Icons.ac_unit),
                    labelText: 'apellidos')),
                  
                

                  TextFormField(
                    controller: _ocupacionController,
                    style: TextStyle( fontSize: 17.0, color: Colors.deepPurple),
                    decoration: InputDecoration(icon: Icon(Icons.ac_unit),
                    labelText: 'ocupacion')),
                   edadOption(),
                   generoOption(),
               

                  FlatButton(onPressed: (){
                    if(widget.paciente.id!=null){
                      genero=widget.paciente.sexo;
                      pacienteReference.child(widget.paciente.id).set({
                        'nombre': _nombreController.text,
                        'apellidos':_apellidosController.text,
                        'edad': edad,
                        'ocupacion':_ocupacionController.text,
                        'sexo': genero,
                        'terapeuta':widget.userId
                      }).then((_){
                        Navigator.pop(context);
                        
                      });
                    }
                    else{
                      pacienteReference.push().set({
                        'nombre': _nombreController.text,
                        'apellidos':_apellidosController.text,
                        'edad': edad,
                        'ocupacion':_ocupacionController.text,
                        'sexo': genero,
                        'terapeuta': widget.userId

                      }).then((_){
                        Navigator.pop(context);
                      });
                    }
                    print('${_nombreController.text}');
                   
                  }, 


                  child: Text('Registrar Paciente')
                  
                  )

                ],
              ),
            ),
          ),
        ),
        ],
        
      ),
    );
  }

  Widget generoOption(){
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
        });
      },
      items: <String>['Femenino','Masculino']
          .map<DropdownMenuItem<String>>((String value) {
              if(widget.paciente.id!=null){
                 return DropdownMenuItem<String>(
               value: value,
               child: Text(widget.paciente.sexo)
               
               );
              }else{
                
                 return DropdownMenuItem<String>(
               value: value,
               child: Text(value),
               );
              }
             

            
       
      }).toList(),
    );
  }


   Widget edadOption(){
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
      items: edades()
          .map<DropdownMenuItem<int>>((dynamic value) {
             if(widget.paciente.id!=null){
                return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
               );
             }else{
                 return DropdownMenuItem<int>(
                  value: value,
                   child: Text('$value'),
                   );
             }
       
      }).toList(),
    );
  }

  List edades(){
    List<int>edades=[];
   
    for (var i = 0; i < 100; i++) {
      edades.add(i);
      print(i);
     
    }
    return edades;
  }
  

}