import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/pages/View/NavigationBar.dart';
import 'package:therapp/src/pages/View/VerPaciente.dart';

//METODO SPARA GUARDAR LAS FOTOS E IMAGENES 
File image;
String filename;

/*CLASE PARA REGISTRAR PACIENTES */
class RegistrarPaciente extends StatefulWidget {
  final Paciente paciente;
  final String userId;
  final bool app;
  RegistrarPaciente({Key key, this.paciente, this.userId, this.app}) : super(key: key);

  @override
  _RegistrarPacienteState createState() => _RegistrarPacienteState();
}

final pacienteReference =
    FirebaseDatabase.instance.reference().child('paciente');

class _RegistrarPacienteState extends State<RegistrarPaciente> {
  //VARIABLES INICIALES 
   TextEditingController _inputFieldDateController;
  final _formKey = GlobalKey<FormState>();
  List<Paciente> items;

  TextEditingController _nombreController;
  TextEditingController _apellidosController;
  TextEditingController _edadController;
  TextEditingController _ocupacionController;
  TextEditingController _sexoController;
  String genero = 'Masculino';

  String pacienteImage;
  String fecha;
//METODOS PARA ESCOJER IMAGEN  O FOTO 

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

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

    _inputFieldDateController = new TextEditingController(text: widget.paciente.nacimiento);
    pacienteImage = widget.paciente.imagenPaciente;
    print(pacienteImage);
  }
//METODO DE DIBUJO DE PANTALLA 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.app == false ? null : 
      AppBar(
        backgroundColor: Colors.teal[500],
        title: Text('Editar Registro'),
      ),
      body: Builder(
        builder: (BuildContext context ){
          return ListView(
        children: <Widget>[
           imagenes(),
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
                              TextStyle(fontSize: 17.0),
                          decoration: decoracion('Nombre',Icons.people),
                           validator: (value){
                              value=_nombreController.text;
                                    if(value.isEmpty){
                                      return 'Favor de introducir un nombre';
                                    }else{
                 
                                        }},
                              ),
                              Divider(),
                      TextFormField(
                          controller: _apellidosController,
                          style:
                              TextStyle(fontSize: 17.0),
                          decoration: decoracion('Apellidos',Icons.people),
                          
                           validator: (value){
                              value=_apellidosController.text;
                                    if(value.isEmpty){
                                      return 'Favor de introducir apellidos';
                                    }else{
                 
                                        }},
                              ),
                              Divider(),
                              _crearFecha(context),
                              Divider(),
                      TextFormField(
                          controller: _ocupacionController,
                          style:
                              TextStyle(fontSize: 17.0),
                          decoration: decoracion('Ocupacion',Icons.assignment),
                          
                           validator: (value){
                              value=_ocupacionController.text;
                                    if(value.isEmpty){
                                      return 'Favor de introducir su ocupacion';
                                    }else{
                 
                                        }},

                              ),
                              Divider(),
                     
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _crearGenero(context),
                          VerticalDivider(
                            width: 20.0,
                          ),
                           generoOption()
                        ],
                      ),
                      Divider(),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         _crearEdad(context),
                   
                       ],
                     ),
                     
                   
                      
                      Divider(),
                      
                     // generoOption(),
                      FlatButton(
                          color: Colors.teal[300],
                        //METODO PARA ENVIAR DATOS A LA PLATAFORMA 
                          onPressed: () {
                            //EXCEPCION PARA LA FOTO DE PERFIL
                           try{
                               if(_formKey.currentState.validate()){

                                 if (widget.paciente.id != null) {
                                    var fecha = formatDate(
                                    new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                               var fullImageName = 'paciente-${_nombreController.text}-$fecha' + '.jpg';
                               var fullImageName2 = 'paciente-${_nombreController.text}-$fecha' + '.jpg';
                               final StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
                               final StorageUploadTask task = ref.putFile(image);

                               var part1 = 'https://firebasestorage.googleapis.com/v0/b/therapp-33c50.appspot.com/o/';

                               var fullPathImage = part1 + fullImageName2;
                               print(fullPathImage);
                             
                              genero = widget.paciente.sexo;
                              pacienteReference.child(widget.paciente.id).set({
                                'nombre': _nombreController.text,
                                'apellidos': _apellidosController.text,
                                'nacimiento': _inputFieldDateController.text,
                                'edad': _edadController.text,
                                'ocupacion': _ocupacionController.text,
                                'sexo': _sexoController.text,
                                'terapeuta': widget.userId,
                                'imagen': '$fullPathImage'
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              var fecha = formatDate(
                                    new DateTime.now(), [yyyy, '-', mm, '-', dd]);

                               var fullImageName = 'terapeuta-${_nombreController.text}-$fecha' + '.jpg';
                               var fullImageName2 = 'terapeuta-${_nombreController.text}-$fecha' + '.jpg';
                               final StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
                               final StorageUploadTask task = ref.putFile(image);

                               var part1 = 'https://firebasestorage.googleapis.com/v0/b/therapp-33c50.appspot.com/o/';

                               var fullPathImage = part1 + fullImageName2;
                               print(fullPathImage);


                              pacienteReference.push().set({
                                'nombre': _nombreController.text,
                                'apellidos': _apellidosController.text,
                                'nacimiento': _inputFieldDateController.text,
                                'edad': _edadController.text,
                                'ocupacion': _ocupacionController.text,
                                'sexo': genero,
                                'terapeuta': widget.userId,
                                'imagen': '$fullPathImage'
                              }).then((_) {
                               
                                final snackBar = SnackBar(
                                  
                                  content: Text('Paciente  Registrado Exitosamente',
                                   style: TextStyle(
                                     decorationColor: Colors.white
                                   )
                                   ),
                                  backgroundColor: Colors.green,
                                  );

                                Scaffold.of(context).showSnackBar(snackBar);
                              });
                            }


                             }
                            }catch(e){
                              print('$e JAJAJAJA QUE MAMADA');
                              final snackBar = SnackBar(
                                   content: Text('Debe insertar una foto del paciente',
                                   style: TextStyle(
                                     decorationColor: Colors.white
                                   ),
                                   ),
                                   backgroundColor: Colors.red,
                                   );
             
                                    Scaffold.of(context).showSnackBar(snackBar);
                            
                            }
                            
                          
                            print('${_nombreController.text}');
                          },
                          child: Text('Registrar Paciente', style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
        },
      )
    );
  }

//METODO PARA CREAR LISTA DE GENEROS
Widget _crearGenero(BuildContext context){
  if(widget.paciente.id == null){
     _sexoController.text = genero;
  }
    return Container(
      width: 180.0,
      child: TextFormField(
        
         validator: (value){
                         value=_sexoController.text;
                       if(value.isEmpty){
                         return 'Favor de añadir un genero';
                       }
                        },
        //Pasamos la fecha por aqui
        controller: _sexoController,
        //Desactivamos la accion interactiva
        enableInteractiveSelection: false,
       //Añadir estilo a la caja de texto
        decoration: decoracion('Genero',Icons.account_balance,'Sexo'),
      ),
    );



}

  Widget generoOption() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0, 0.0,0),
      child: DropdownButton<String>(
        value: genero,
      
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.teal[500]),
        underline: Container(
          height: 2,
          color: Colors.teal[500],
        ),
        onChanged: (String newValue) {
          setState(() {
            genero = newValue;
            _sexoController.text = genero;
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
      ),
    );
  }

//METODO PARA CREAR LISTA DE EDADES
Widget _crearEdad(BuildContext context){
  
    
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0, 110.0,0),
      width: 180.0,
      child: TextFormField(
         keyboardType: TextInputType.number,
         validator: (value){
                         value=_edadController.text;
                       if(value.isEmpty){
                         return 'Favor de añadir la edad';
                       }
                        },
        //Pasamos la fecha por aqui
        controller: _edadController,
        //Desactivamos la accion interactiva
        enableInteractiveSelection: false,
       //Añadir estilo a la caja de texto
        decoration: decoracion('Edad',Icons.person_outline,'Edad'),

           
        
         
      ),
    );



}



  
//METODO PARA CREAR CALENDARIO
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
      decoration: decoracion('Fecha de nacimiento',Icons.calendar_today),

         
      
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
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2025),
     //Cambiar el idioma del cuadro de fechas
     //mOSTRARA UN ERROR DE FORMA NORMAL SI NO EXISTE UNA DEPENDENCIA
     // locale: Locale('fr','CH'),

    );
    //Con esta condicional vamos a meter la informacion de la fecha en el cuadro de texto
  
    if (picked != null){
       setState(() {
        dynamic estorboDia = picked.day < 10 ? 0 : '';
        dynamic estorboMes = picked.month < 10 ? 0 : '';
        String _fecha = "${picked.year}-$estorboMes${picked.month}-$estorboDia${picked.day}";


        _inputFieldDateController.text = _fecha;
      });
    }

  }

//METODO PARA CREA ICONOS DE ELECCION DE FOTO O IMAGEN
  Widget imagenes(){
  return Column(
     
      children: <Widget>[
        Form(
          child: Column(
            children: <Widget>[
            
                
                  Container(
                    
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      //color: Colors.black,
                      border: Border.all(
                        color: Colors.black
                      ),
                    ),
                    padding: EdgeInsets.all(5.0),
                    child: FadeInImage(
                           width: 150.0,
                           height: 150.0,
                           fadeInCurve: Curves.bounceIn,
                           placeholder:  AssetImage('assets/images/icon-app.jpeg'), 
                           image:image == null ? AssetImage('assets/images/photo-null.jpeg') : FileImage(image)//Image.file(image), 
              ),
                    /*image == null ? Image.asset('assets/images/photo-null.jpeg') : Image.file(image),*/
                  ),
               
              Container(
                //height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.black
                      )),

                child: Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                     IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white,),
                  onPressed: pickerCam,
                ),
            
                IconButton(
                  icon: Icon(Icons.collections, color: Colors.white),
                  onPressed: pickerGallery,
                ),
                  ],
                ),
              ),
             
              
            
            
            ],
            

          ),
        ),
    
      ]
    );




}
//METODO PARA FORMATO DE FORMULARIO 
InputDecoration decoracion(String nombre, IconData icono,[String label]){
  return InputDecoration(
    suffix: label == null
    ? null : Text('$label'),
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


 Widget _fotoPerifl() {
    return Column(children: <Widget>[
      Form(
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                border: Border.all(width: 5.5, color: Colors.black),
              ),
              padding: EdgeInsets.all(5.0),
              child: pacienteImage != null
                  ? Image.network(pacienteImage + '?alt=media')
                  : Image.asset('assets/images/photo-null.jpeg'),
            ),
            Container(
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.black, border: Border.all(color: Colors.black)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: pickerCam,
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: pickerGallery,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }



}
