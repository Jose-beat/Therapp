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
  String _opcionSeleccionada = "Masculino";
  List<String> _poderes = ['volar','RayosX','Super Aliento','Super Fuerza'];
  List<Paciente>items;

  TextEditingController _nombreController;
  TextEditingController _apellidosController;
  TextEditingController _edadController;
  TextEditingController _ocupacionController;
  TextEditingController _sexoController;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nombreController = new TextEditingController(text:widget.paciente.nombre);
    _apellidosController = new TextEditingController(text:widget.paciente.apellidos);
    _edadController = new   TextEditingController(text: widget.paciente.edad);
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
                    controller: _edadController,
                    style: TextStyle( fontSize: 17.0, color: Colors.deepPurple),
                    decoration: InputDecoration(icon: Icon(Icons.ac_unit),
                    labelText: 'edad')),

                  TextFormField(
                    controller: _ocupacionController,
                    style: TextStyle( fontSize: 17.0, color: Colors.deepPurple),
                    decoration: InputDecoration(icon: Icon(Icons.ac_unit),
                    labelText: 'ocupacion')),

                  TextFormField(
                    controller: _sexoController,
                    style: TextStyle( fontSize: 17.0, color: Colors.deepPurple),
                    decoration: InputDecoration(icon: Icon(Icons.ac_unit),
                    labelText: 'sexo')),
                  ListTile(
                    title: Text('data'),
                    leading: Radio(value: false, groupValue: null, onChanged: null),
                  ),
         
                   DropdownButton<String>(
                      items: const <String>['A', 'B', 'C', 'D'].map((String value) {
                        return  DropdownMenuItem<String>(
                       value: value,
                        child: Text(value),
                      );
                       }).toList(),
                        onChanged: (value) {
                          setState(() {
                            value=='b';
                          });
                        },
                          ),
               

                  FlatButton(onPressed: (){
                    if(widget.paciente.id!=null){
                      pacienteReference.child(widget.paciente.id).set({
                        'nombre': _nombreController.text,
                        'apellidos':_apellidosController.text,
                        'edad': _edadController.text,
                        'ocupacion':_ocupacionController.text,
                        'sexo': _sexoController.text,
                        'terapeuta':widget.userId
                      }).then((_){
                        Navigator.pop(context);
                        
                      });
                    }
                    else{
                      pacienteReference.push().set({
                        'nombre': _nombreController.text,
                        'apellidos':_apellidosController.text,
                        'edad': _edadController.text,
                        'ocupacion':_ocupacionController.text,
                        'sexo': _sexoController.text,
                        'terapeuta': widget.userId

                      }).then((_){
                        Navigator.pop(context);
                      });
                    }
                    print('${_nombreController.text}');
                   
                  }, 


                  child: Text('Registrar Paciente ${widget.paciente.id}')
                  
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


  

}