import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/SignosVitales.dart';

/*METODO PARA EL REGISTRO DE SIGNOS VITLKES*/
class RegistroSignosVitales extends StatefulWidget {
  final SignosVitales signosVitales;
  RegistroSignosVitales({Key key, this.signosVitales}) : super(key: key);

  @override
  _RegistroSignosVitalesState createState() => _RegistroSignosVitalesState();
}

final signosVitalesReference =
    FirebaseDatabase.instance.reference().child('signos_vitales');

class _RegistroSignosVitalesState extends State<RegistroSignosVitales> {

  //VARIABLES INICALES
    final _formKey = GlobalKey<FormState>();
  List<SignosVitales> items;
  String frecuenciaCardiActual = '70 - 190';
  String frecuenciaRespiratoryActual = '30 - 80';

  String talla = 'XS';
  String _fecha;
  TextEditingController _inputFieldDateController;
  TextEditingController _inputFieldHoraController;

  TextEditingController _fcController;
  TextEditingController _frController;
  TextEditingController _pesoController;
  TextEditingController _tallaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputFieldHoraController = new TextEditingController(text:widget.signosVitales.hora);

    _inputFieldDateController = new TextEditingController(text: widget.signosVitales.fechaSignos);
    _fcController = new TextEditingController(text: widget.signosVitales.fc);
    _frController = new TextEditingController(text: widget.signosVitales.fr);
    _pesoController =
        new TextEditingController(text: widget.signosVitales.peso.toString());
    _tallaController =
        new TextEditingController(text: widget.signosVitales.talla.toString());
  }
//METODOS PARA DIBUJAR FORMULARIO EN PANTALLA 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Signos Vitales'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              _crearCardiaco(context),
                              Divider(),
                              _crearRespiracion(context),
                              Divider(),
                              _crearPeso(context),
                              Divider(),
                              _crearTalla(context),
                              Divider(),

                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              cardiacOption(),
                     
                              respiratoryOption(),
                             
                              Divider( height: 60.0,),
                          
                              tallaOption(),
                            ],
                          )
                        ],
                      ),
                      
                      _crearFecha(context),
                      Divider(),
                      _crearHora(context),


                      FlatButton(

                        //METODO PARA EL ENVIO DE DATOS 
                          onPressed: () {
                            if(_formKey.currentState.validate()){
                            if (widget.signosVitales.id != null) {
                              signosVitalesReference
                                  .child(widget.signosVitales.id)
                                  .set({
                                'frecuencia cardiaca': _fcController.text,
                                'frecuencia respiratoria':
                                    _frController.text,
                                'peso': _pesoController.text,
                                'talla': _tallaController.text,
                                'fecha':_inputFieldDateController.text,
                                'hora':_inputFieldHoraController.text,
                                'paciente': widget.signosVitales.paciente
                              }).then((_) {
                                Navigator.pop(context);
                              });
                            } else {
                              signosVitalesReference.push().set({
                                'frecuencia cardiaca': frecuenciaCardiActual,
                                'frecuencia respiratoria':
                                    frecuenciaRespiratoryActual,
                                'peso': _pesoController.text,
                                'talla': talla,
                                'fecha':_inputFieldDateController.text,
                                'hora':_inputFieldHoraController.text,
                                'paciente': widget.signosVitales.paciente
                              }).then((_) {
                                 Navigator.pop(context);
                              });
                            }
                            }
                          },
                          child: Text('Siguiente'))
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
  //METODO PARA CREAR LISTA DE FC
Widget _crearCardiaco(BuildContext context){
  if(widget.signosVitales.id == null){
    _fcController.text = frecuenciaCardiActual;
  }
    
    return  Container(
      width: 150.0,
      child: TextFormField(
        readOnly: true,
          validator: (value){
            value=_fcController.text;
            if(value.isEmpty){
              return 'Favor de añadir la fecha';
            }
          },
          //Pasamos la fecha por aqui
          controller: _fcController,
          //Desactivamos la accion interactiva
          enableInteractiveSelection: false,
         //Añadir estilo a la caja de texto
          decoration: decoracion('FC', Icons.timeline, Colors.green[200]),
            
            //Sera un texto original en la caja
         
   
             
          
           
        ),
    );
    

}

  Widget cardiacOption() {
    return Container(
     
      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: DropdownButton<String>(
        isDense: true,
        value: frecuenciaCardiActual,
        //icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color:  Colors.green[500]),
        underline: Container(
          
          height: 2,
          color: Colors.green[300],
        ),
        onChanged: (String newValue) {
          setState(() {
            frecuenciaCardiActual = newValue;
            _fcController.text = frecuenciaCardiActual;
          });
        },
        items: <String>[
          '70 - 190',
          '80 - 160',
          '80 - 130',
          '80 - 120',
          '75 - 115',
          '70 - 110',
          '60 - 100'
        ].map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

//METODO PARA CREAR LISTA DE FR
Widget _crearRespiracion(BuildContext context){
  if(widget.signosVitales.id == null){
     _frController.text =  frecuenciaRespiratoryActual;
  }
 
    return  Container(
     width: 150.0,
      child: TextFormField(
           readOnly: true,
          validator: (value){
            value=_frController.text;
            if(value.isEmpty){
              return 'Debe añadir la frecuencia Respiratoria';
            }
          },
          //Pasamos la fecha por aqui
          controller: _frController,
          //Desactivamos la accion interactiva
          enableInteractiveSelection: false,
         //Añadir estilo a la caja de texto
          decoration: decoracion('FR', Icons.insert_chart, Colors.blue[200]),

        ),
    );
    

}
  Widget respiratoryOption() {
    return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: DropdownButton<String>(
        value: frecuenciaRespiratoryActual,
       
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.blue[500]),
        underline: Container(
          height: 2,
          color:Colors.blue[500],
        ),
        onChanged: (String newValue) {
          setState(() {
            frecuenciaRespiratoryActual = newValue;
            _frController.text = frecuenciaRespiratoryActual;
          });
        },
        items: <String>['30 - 80', '20 - 40', '20 - 30', '20 - 25', '15 - 20']
            .map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

//METODO PARA CREAR LISTA DE PESOS
Widget _crearPeso(BuildContext context){
  
    return  Container(
      width: 150.0,
      child: TextFormField(
           
          validator: (value){
            value=_pesoController.text;
            if(value.isEmpty){
              return 'Debe especificar el peso';
            }
          },
          //Pasamos la fecha por aqui
          controller: _pesoController,
          keyboardType: TextInputType.number,
          
         //Añadir estilo a la caja de texto
          decoration: decoracion('Peso', Icons.straighten, Colors.purple[200]),
            
            //Sera un texto original en la caja
         
   
            
        ),
    );
    

}


  //METODO PARA CREAR LISTA DE TALLAS
Widget _crearTalla(BuildContext context){
   if(widget.signosVitales.id == null){
     _tallaController.text = talla;
  }
  
    return  Container(
      width: 150.0,
      child: TextFormField(
           readOnly: true,
          validator: (value){
            value=_tallaController.text;
            if(value.isEmpty){
              return 'Debe especificar una talla';
            }
          },
          //Pasamos la fecha por aqui
          controller: _tallaController,
          //Desactivamos la accion interactiva
          enableInteractiveSelection: false,
         //Añadir estilo a la caja de texto
          decoration: decoracion('Talla', Icons.view_stream, Colors.brown),
            
            //Sera un texto original en la caja
         
   
             
          
      
        ),
    );
    

}

  Widget tallaOption() {
    return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: DropdownButton<String>(
        value: talla,
        
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.brown),
        underline: Container(
          height: 2,
          color: Colors.brown,
        ),
        onChanged: (String newValue) {
          setState(() {
            talla = newValue;
            _tallaController.text = talla;
          });
        },
        items: <String>['XS', 'S', 'M', 'L', 'XL', 'XXL']
            .map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

//METODO PARA CREAR CALENDARIO
Widget _crearFecha(BuildContext context){

    return  TextFormField(
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
        decoration: decoracion('Fecha de captura', Icons.calendar_today, Colors.blueGrey),
          
          //Sera un texto original en la caja
       
   
           
        
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





//METODO PARA CREAR RELOJ DE HORA
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
      decoration: decoracion('Hora de captura',Icons.hourglass_empty,Colors.blueGrey),

        //Sera un texto original en la caja
      
   
         
      
        onTap: (){
          //Quitar el foco que significa que el teclado no se activara
          FocusScope.of(context).requestFocus(new FocusNode());
          _seleccionHora(context);
        }
        );

  }



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

//METODO PARA FORMATO DEL FORMULARIO

InputDecoration decoracion(String nombre, IconData icono, Color color){
  return InputDecoration(
    
    border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: nombre,
            suffixText: nombre,
            hintStyle: TextStyle(),
            prefixIcon: new Icon(
              icono,
              color: color,
            ));
}







}
