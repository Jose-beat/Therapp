import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:therapp/src/models/Terapeuta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/pages/Login/LoginApp.dart';
import 'package:therapp/src/providers/authentApp.dart';

class RegistroPerfil extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final Terapeuta terapeuta;
  final String id;
  final String email;
  
  RegistroPerfil(
      {Key key,
      this.terapeuta,
      this.auth,
      this.loginCallback,
      this.id,
      this.email})
      : super(key: key);

  @override
  _RegistroPerfilState createState() => _RegistroPerfilState();
}

final terapeutaReference =
    FirebaseDatabase.instance.reference().child('terapeuta');

class _RegistroPerfilState extends State<RegistroPerfil> {
   File imagen;
   TextEditingController _inputFieldDateController;

  final _formKey = GlobalKey<FormState>();
  List<Terapeuta> item;

  TextEditingController _nombreController;
  TextEditingController _apellidosController;
  TextEditingController _clinicaController;
  TextEditingController _especialidadController;
  TextEditingController _telefonoController;
  TextEditingController _emailController;
  TextEditingController _cedulaController;
  String imagenTerapeuta;

  @override
  void initState() {
    super.initState();

    _nombreController =
        new TextEditingController(text: widget.terapeuta.nombre);
    _apellidosController =
        new TextEditingController(text: widget.terapeuta.apellidos);
    _clinicaController =
        new TextEditingController(text: widget.terapeuta.clinica);
    _especialidadController =
        new TextEditingController(text: widget.terapeuta.especialidad);
    _telefonoController =
        new TextEditingController(text: widget.terapeuta.telefono);
    _emailController = new TextEditingController(text: widget.email);
    _cedulaController =
        new TextEditingController(text: widget.terapeuta.cedula);
    imagenTerapeuta = widget.terapeuta.imagen;
    _inputFieldDateController  = new TextEditingController(text: widget.terapeuta.nacimiento);



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: ListView(
          children: <Widget>[
            imagenes(),
            registro(),
            Container(
              height: 100.0,
            )
          ],
        )),
      ),
    );
  }

  Widget registro() {
    return Form(
      key: _formKey,
          child: Column(
        
        children: <Widget>[
            
          
          TextFormField(
            
            keyboardType: TextInputType.text,
            controller: _nombreController,
            
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration:
                InputDecoration(icon: Icon(Icons.person), labelText: 'Nombre'),
            validator: (value){
              value=_nombreController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
             
            },
          
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _apellidosController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration:
                InputDecoration(icon: Icon(Icons.code), labelText: 'Apellidos'),
            validator: (value){
              value=_apellidosController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
           _crearFecha(context),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _clinicaController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.description), labelText: 'Clinica Actual'),
            validator: (value){
              value=_clinicaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _cedulaController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.description), labelText: 'Cedula Profesional'),
            validator: (value){
              value=_cedulaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _especialidadController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.attach_money), labelText: 'Especialidad'),
            validator: (value){
             value=_cedulaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _telefonoController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.satellite), labelText: 'Telefono'),
            validator: (value){
              value=_telefonoController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
           enabled: false,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
              icon: Icon(Icons.satellite),
              labelText: 'Correo Electronico',
            ),
            validator: (value){
              value=_emailController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          
          FlatButton(
              onPressed: () {
                if(_formKey.currentState.validate()){
                  if (widget.terapeuta.id != null) {
                  var fecha = formatDate(
                      new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                   var fullImageName = 'terapeuta-${_nombreController.text}-$fecha' + '.jpg';
                   var fullImageName2 = 'terapeuta-${_nombreController.text}-$fecha' + '.jpg';
                   final StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
                   final StorageUploadTask task = ref.putFile(imagen);

                   var part1 = 'https://firebasestorage.googleapis.com/v0/b/therapp-33c50.appspot.com/o/';

                   var fullPathImage = part1 + fullImageName2;
                   print(fullPathImage);
                    



                  terapeutaReference.child(widget.terapeuta.id).set({

                    'nombre': _nombreController.text,
                    'apellidos': _apellidosController.text,
                    'nacimiento': _inputFieldDateController.text,
                    'cedula': _cedulaController.text,
                    'clinica': _clinicaController.text,
                    'especialidad': _especialidadController.text,
                    'telefono': _telefonoController.text,
                    'email': _emailController.text,
                    'imagen':'$fullPathImage'
                    
                  }).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                    var fecha = formatDate(
                    new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                   var fullImageName = 'terapeuta-${_nombreController.text}-$fecha' + '.jpg';
                   var fullImageName2 = 'terapeuta-${_nombreController.text}-$fecha' + '.jpg';
                   final StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
                   final StorageUploadTask task = ref.putFile(imagen);

                   var part1 = 'https://firebasestorage.googleapis.com/v0/b/therapp-33c50.appspot.com/o/';

                   var fullPathImage = part1 + fullImageName2;
                   print(fullPathImage);
                    

                  
                  terapeutaReference.push().set({
                    'nombre': _nombreController.text,
                    'apellidos': _apellidosController.text,
                    'nacimiento': _inputFieldDateController.text,
                    'cedula': _cedulaController.text,
                    'clinica': _clinicaController.text,
                    'especialidad': _especialidadController.text,
                    'telefono': _telefonoController.text,
                    'email': _emailController.text,
                    'imagen':'$fullPathImage'
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
                }
                
                print('jajaja no mames ${_emailController.text}');
              },
              child: widget.terapeuta.id != null ? Text('Actualizar Perfil') : Text('Crear Perfil')
              )
        ],
      ),
    );
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

   pickerCam()async{
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
  if(img != null){
    imagen = img;
    setState(() {
      
    });
  }
  } 

  pickerGallery()async{
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);

  if(img != null){
    imagen = img;
    setState(() {
      
    });
  }
  }

  void createData()async {
     
     var fullImageName = 'terapeuta-${_nombreController.text}' + '.jpg';
     var fullImageName2 = 'terapeuta-${_nombreController.text}' + '.jpg';
     final StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
     final StorageUploadTask task = ref.putFile(imagen);

     var part1 = 'https://firebasestorage.googleapis.com/v0/b/therapp-33c50.appspot.com/o/';

     var fullPathImage = part1 + fullImageName2;
     print(fullPathImage);
  
  }

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
                      border: Border.all(
                        color: Colors.blueAccent
                      ),
                    ),
                    padding: EdgeInsets.all(5.0),
                    child: imagen == null ? Text('Add') : Image.file(imagen),
                  ),
               
              
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: pickerCam,
              ),
            
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: pickerGallery,
              ),
              
            
            
            ],
            

          ),
        ),
    
      ]
    );




}
}