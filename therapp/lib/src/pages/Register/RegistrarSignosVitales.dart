import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/SignosVitales.dart';

class RegistroSignosVitales extends StatefulWidget {
  final SignosVitales signosVitales;
  RegistroSignosVitales({Key key, this.signosVitales}) : super(key: key);

  @override
  _RegistroSignosVitalesState createState() => _RegistroSignosVitalesState();
}

final signosVitalesReference =
    FirebaseDatabase.instance.reference().child('signos_vitales');

class _RegistroSignosVitalesState extends State<RegistroSignosVitales> {
    final _formKey = GlobalKey<FormState>();
  List<SignosVitales> items;
  String frecuenciaCardiActual = '70 - 190';
  String frecuenciaRespiratoryActual = '30 - 80';
  int peso = 40;
  String talla = 'XS';
  String _fecha;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldHoraController = new TextEditingController();

  TextEditingController _fcController;
  TextEditingController _frController;
  TextEditingController _pesoController;
  TextEditingController _tallaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fcController = new TextEditingController(text: widget.signosVitales.fc);
    _frController = new TextEditingController(text: widget.signosVitales.fr);
    _pesoController =
        new TextEditingController(text: widget.signosVitales.peso.toString());
    _tallaController =
        new TextEditingController(text: widget.signosVitales.talla.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Signos Vitales'),
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
                             
                              pesoOption(),
                          
                              tallaOption(),
                            ],
                          )
                        ],
                      ),
                      
                      _crearFecha(context),
                      Divider(),
                      _crearHora(context),


                      FlatButton(
                          onPressed: () {
                            if(_formKey.currentState.validate()){
                            if (widget.signosVitales.id != null) {
                              signosVitalesReference
                                  .child(widget.signosVitales.id)
                                  .set({
                                'frecuencia cardiaca': frecuenciaCardiActual,
                                'frecuencia respiratoria':
                                    frecuenciaRespiratoryActual,
                                'peso': peso,
                                'talla': talla,
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
                                'peso': peso,
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

Widget _crearCardiaco(BuildContext context){
    _fcController.text = frecuenciaCardiActual;
    return  Container(
      width: 150.0,
      child: TextFormField(
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
          decoration: decoracion('Fc', Icons.calendar_today),
            
            //Sera un texto original en la caja
         
   
             
          
           
        ),
    );
    

}

  Widget cardiacOption() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: DropdownButton<String>(
        value: frecuenciaCardiActual,
        //icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            frecuenciaCardiActual = newValue;
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


Widget _crearRespiracion(BuildContext context){
  _frController.text =  frecuenciaRespiratoryActual;
    return  Container(
     width: 150.0,
      child: TextFormField(
          validator: (value){
            value=_frController.text;
            if(value.isEmpty){
              return 'Favor de añadir la fecha';
            }
          },
          //Pasamos la fecha por aqui
          controller: _frController,
          //Desactivamos la accion interactiva
          enableInteractiveSelection: false,
         //Añadir estilo a la caja de texto
          decoration: decoracion('FC', Icons.calendar_today),

        ),
    );
    

}
  Widget respiratoryOption() {
    return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: DropdownButton<String>(
        value: frecuenciaRespiratoryActual,
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
            frecuenciaRespiratoryActual = newValue;
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


Widget _crearPeso(BuildContext context){
  _pesoController.text = peso.toString();
    return  Container(
      width: 150.0,
      child: TextFormField(
          validator: (value){
            value=_pesoController.text;
            if(value.isEmpty){
              return 'Favor de añadir la fecha';
            }
          },
          //Pasamos la fecha por aqui
          controller: _pesoController,
          //Desactivamos la accion interactiva
          enableInteractiveSelection: false,
         //Añadir estilo a la caja de texto
          decoration: decoracion('Peso', Icons.calendar_today),
            
            //Sera un texto original en la caja
         
   
            
        ),
    );
    

}
  Widget pesoOption() {
    return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: DropdownButton<int>(
        value: peso,
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
            peso = newValue;
          });
        },
        items: pesos().map<DropdownMenuItem<int>>((dynamic value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
      ),
    );
  }

  List pesos() {
    List<int> peso = [];

    for (var i = 30; i < 100; i += 10) {
      peso.add(i);
      print(i);
    }
    return peso;
  }

  
Widget _crearTalla(BuildContext context){
    _tallaController.text = talla;
    return  Container(
      width: 150.0,
      child: TextFormField(
          validator: (value){
            value=_tallaController.text;
            if(value.isEmpty){
              return 'Favor de añadir la fecha';
            }
          },
          //Pasamos la fecha por aqui
          controller: _tallaController,
          //Desactivamos la accion interactiva
          enableInteractiveSelection: false,
         //Añadir estilo a la caja de texto
          decoration: decoracion('Fecha de captura', Icons.calendar_today),
            
            //Sera un texto original en la caja
         
   
             
          
      
        ),
    );
    

}

  Widget tallaOption() {
    return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: DropdownButton<String>(
        value: talla,
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
            talla = newValue;
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
        decoration: decoracion('Fecha de captura', Icons.calendar_today),
          
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
      decoration: decoracion('Hora de captura',Icons.hourglass_empty),

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
