import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:therapp/src/models/consultas.dart';


/*METODO PARA REGISTRAR CONSULTAS */
class ResConsultas extends StatefulWidget {
  final String idTerapeuta;
  final Consultas consultas;

  ResConsultas({Key key, this.consultas, this.idTerapeuta}) : super(key: key);

  @override
  _ResConsultasState createState() => _ResConsultasState();
}

final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _ResConsultasState extends State<ResConsultas> {


//VARIABLES INICALES 
  final _formKey = GlobalKey<FormState>();
  List<Consultas> items;
  String _fecha;

  TextEditingController _motivoController;
  TextEditingController _inputFieldDateController;
  TextEditingController _inputFieldHoraController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputFieldDateController = new TextEditingController(text: widget.consultas.fechaConsulta);
    _inputFieldHoraController = new TextEditingController(text: widget.consultas.horaConsulta);
    _motivoController =
        new TextEditingController(text: widget.consultas.motivos);
  }
//METODO PARA DIBUJAR PANTALLA 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[500],
          title: Text('Consulta')
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
                          controller: _motivoController,
                          style: TextStyle(fontSize: 17.0, color: Colors.orange),
                          decoration: decoracion('Motivo de consulta',Icons.calendar_today),
                               validator: (value){
                              value=_motivoController.text;
                            if(value.isEmpty){
                              return 'Favor de añadir la fecha';
                            }
                             },
                              
                        ),
                        Divider(),
                        _crearFecha(context),
                        Divider(),
                        _crearHora(context),
                        FlatButton(
                            color: Colors.orange,
                            onPressed: () {
                                  //METODO PARA ENVIAR DATOS A LA PLATAFORMA 
                               if(_formKey.currentState.validate()){
                              if (widget.consultas.id != null) {
                                consultasReference
                                    .child(widget.consultas.id)
                                    .set({
                                  'motivos_consulta': _motivoController.text,
                                  'paciente': widget.consultas.idPaciente,
                                  'nombre_paciente': widget.consultas.nombre,
                                  'apellidos_paciente': widget.consultas.apellidos,
                                  'terapeuta':widget.consultas.idTerapeuta,
                                  'fecha':_inputFieldDateController.text,
                                  'hora':_inputFieldHoraController.text
                                }).then((_) {
                                  Navigator.pop(context);
                                });
                              } else {
                                consultasReference.push().set({
                                  'motivos_consulta': _motivoController.text,
                                  'paciente': widget.consultas.idPaciente,
                                  'nombre_paciente': widget.consultas.nombre,
                                  'apellidos_paciente': widget.consultas.apellidos,
                                  'terapeuta':widget.consultas.idTerapeuta,
                                  'fecha':_inputFieldDateController.text,
                                  'hora':_inputFieldHoraController.text
                                }).then((_) {
                                  Navigator.pop(context);
                                });
                              }
                              }
                            },
                            child: Text('Añadir Consulta',
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


//METODO PARA CREAR CLAENDARIO
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
      decoration: decoracion('Fecha de consulta', Icons.calendar_today),
   
         onTap: (){
          //Quitar el foco que significa que el teclado no se activara
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDay(context);
        }
      
        
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



  Widget _crearHora(BuildContext context){
    
     return TextFormField(
       validator: (value){
                              value=_inputFieldHoraController.text;
                            if(value.isEmpty){
                              return 'Favor de añadir la fecha';
                            }
                             },
      //Pasamos la fecha por aqui
      controller: _inputFieldHoraController,
      //Desactivamos la accion interactiva
      enableInteractiveSelection: false,
     //Añadir estilo a la caja de texto
      decoration: decoracion('Hora de la consulta', Icons.airline_seat_legroom_extra),
        
  
   
         
      
        onTap: (){
          //Quitar el foco que significa que el teclado no se activara
          FocusScope.of(context).requestFocus(new FocusNode());
          _seleccionHora(context);
        }
        );

  }
  //METODO PARA CREAR RELOJ DE HORAS

   _seleccionHora(BuildContext context) async {

      TimeOfDay hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    //Con esta condicional vamos a meter la informacion de la fecha en el cuadro de texto

    if (hora != null){
      setState(() {
       String _hora = hora.format(context);
       
       _inputFieldHoraController.text = _hora;
      });
    }

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