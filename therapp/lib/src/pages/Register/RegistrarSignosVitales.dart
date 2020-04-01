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
                      cardiacOption(),
                      respiratoryOption(),
                      pesoOption(),
                      tallaOption(),
                      _crearFecha(context),
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

  Widget cardiacOption() {
    return DropdownButton<String>(
      value: frecuenciaCardiActual,
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
    );
  }

  Widget respiratoryOption() {
    return DropdownButton<String>(
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
    );
  }

  Widget pesoOption() {
    return DropdownButton<int>(
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

  Widget tallaOption() {
    return DropdownButton<String>(
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
        _fecha = "${picked.day} / ${picked.month} / ${picked.year}";
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







}
