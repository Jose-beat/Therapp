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
  final bool imagenPerfil;
  RegistroPerfil(
      {Key key,
      this.terapeuta,
      this.auth,
      this.loginCallback,
      this.id,
      this.email, this.imagenPerfil})
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
        
      
      
        
         backgroundColor: Colors.teal[300],
        elevation: 0.0,
        title: Text('Registrate'),
        
        leading: IconButton(
          icon: Icon(Icons.portrait,
          color: Colors.white,
          ), 
          onPressed: null
          ),
      ),
      body: Builder(
        builder: (BuildContext context){
          return Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: ListView(
          children: <Widget>[
            Container(
              child: widget.imagenPerfil == false ? 
              _fotoPerifl():imagenes()
            ),
            Divider(),
           
            registro(context),
            Container(
              height: 100.0,
            )
          ],
        )),
      );

        }
        )
    );
  }













  Widget registro(BuildContext context) {
    return Form(
      key: _formKey,
          child: Column(
        
        children: <Widget>[
            
          
          TextFormField(
            
            keyboardType: TextInputType.text,
            controller: _nombreController,
            
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
             decoration: new InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Nombre',
            prefixIcon: new Icon(
              Icons.person,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),

            validator: (value){
              value=_nombreController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
             
            },
          
          ),
          Divider(),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _apellidosController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.person,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Apellidos',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
            validator: (value){
              value=_apellidosController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          Divider(),
           _crearFecha(context),
           Divider(),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _clinicaController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
             decoration: new InputDecoration(
               prefixIcon: new Icon(
              Icons.local_hospital,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Clinica-Hospital',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
            validator: (value){
              value=_clinicaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          Divider(),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _cedulaController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
             decoration: new InputDecoration(
               prefixIcon: new Icon(
              Icons.book,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Cedula Profesional',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
            validator: (value){
              value=_cedulaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          Divider(),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _especialidadController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
             decoration: new InputDecoration(
               prefixIcon: new Icon(
              Icons.turned_in_not,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Especialidad',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
            validator: (value){
             value=_cedulaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          Divider(),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _telefonoController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
             decoration: new InputDecoration(
               prefixIcon: new Icon(
              Icons.phone_iphone,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Telefono',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
            validator: (value){
              value=_telefonoController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          Divider(),
          TextFormField(
           enabled: false,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: new InputDecoration(
              prefixIcon: new Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Correo Electronico',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
            validator: (value){
              value=_emailController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          Divider(),
          FlatButton(
              onPressed: () {

                try{
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
                }catch(e){
                    print('ERROR: $e');
                    final snackBar = SnackBar(
                      content: Text('Debe insertar una foto de perfil',
                      style: TextStyle(
                        decorationColor: Colors.white
                      ),
                      ),
                      backgroundColor: Colors.red,
                      );

                       Scaffold.of(context).showSnackBar(snackBar);
                }
               
                
                print('jajaja no mames ${_emailController.text}');
              },
              child: widget.terapeuta.nombre != null ? Text('Actualizar Perfil') : Text('Crear Perfil')
              )
        ],
      ),
    );
  }



  
  


  Widget _fotoPerifl(){

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
                        width: 5.5,
                        color: Colors.black
                      ),
                    ),
                    
                    padding: EdgeInsets.all(5.0),
                    child:  widget.terapeuta.imagen != null ? 
                     Image.network(widget.terapeuta.imagen + '?alt=media') :
                     Image.asset('assets/images/photo-null.jpeg'),
                  ),
               
              
              Container(
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
                      icon: Icon(Icons.camera_alt),
                      onPressed: pickerCam,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: pickerGallery,
                      color: Colors.white,
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
       decoration: new InputDecoration(
         prefixIcon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Fecha de nacimiento',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),)),
   
         
      
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
        dynamic estorboDia = picked.day < 10 ? 0 : '';
        dynamic estorboMes = picked.month < 10 ? 0 : '';
        String _fecha = "${picked.year}-$estorboMes${picked.month}-$estorboDia${picked.day}";


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
                        width: 5.5,
                        color: Colors.black
                      ),
                    ),

                    padding: EdgeInsets.all(5.0),
                    child: imagen == null ? Image.asset('assets/images/photo-null.jpeg') : Image.file(imagen),
                  ),
               
              
              Container(

                 width: 200.0,
                decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.black
                      )),
                      
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: pickerCam,
                      color: Colors.white,
                    ),
                     IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: pickerGallery,
                      color: Colors.white
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



}