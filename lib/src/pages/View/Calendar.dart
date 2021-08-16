import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:therapp/src/models/Paciente.dart';

import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';

/*Esta clase se encarga de dibujar una pantalla que muestra un calendario 
junto a una lista global de consultas ademas de su estatus*/

class ConsultasActuales extends StatefulWidget {
  final String idTerapeuta;
  final String idPaciente;
  final Consultas consultas;
  ConsultasActuales(
      {Key key, this.idTerapeuta, this.idPaciente, this.consultas})
      : super(key: key);

  @override
  _ConsultasActualesState createState() => _ConsultasActualesState();
}

/*Definimos una instancia de la base de datos*/
final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _ConsultasActualesState extends State<ConsultasActuales> {

/*Estado actual de cada dato */

  bool _cargando = true;
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _consultas;
  TextEditingController _consultaController;
  List<dynamic> _selectedEvents;
  DateTime _diaActual = DateTime.now();
  SharedPreferences prefs;

/*-------------------------------------------------------ATRIBUTOS DE BASE DE DATOS---------------------------------------------*/
  StreamSubscription<Event> _onConsultaAddedSubscription;
  StreamSubscription<Event> _onConsultaChangedSubscription;


/* Definimos variables al arrancar la app*/
  @override
  void initState() {
    startTime();
    super.initState();
    final _selectedDay = DateTime.now();
    items = new List();
    itemPaciente = new List();
    _onConsultaAddedSubscription =
        consultasReference.onChildAdded.listen(_onConsultasAdded);
    _onConsultaChangedSubscription =
        consultasReference.onChildChanged.listen(_onConsultasUpdate);

    _calendarController = CalendarController();
    _consultas = {};
    _consultaController = TextEditingController();
    _selectedEvents = [];
  }
  

//Cronometro para el manejo de la caga de datos 
  Future<Timer> startTime() async {
    var _duration = Duration(seconds: 10);
    return Timer(_duration, cambioDatos);
  }

  Widget _progresoCircular() {
    print(_cargando.toString());

    if (_cargando == true) {
      print(_cargando.toString());

      return Center(
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      );
    } else {
      return Container();
    }
  }

 
//METODO QUE CAMBIARA EL ESTADO DEL METODO ANTERIOR 
  void cambioDatos() {

    
      _cargando = false;

  }

 


 /* Este metodo se encarga de dibujar cada consulta perteneciente al terapeurta, su 
 hor, fecha y nombre del paciente*/

  dynamic _filter(BuildContext context, int position) {
    print('TERAPEUTA1: ${items[position].idTerapeuta}');
    print('TERAPEUTA2: ${widget.idTerapeuta}');

    if (items[position].idTerapeuta == widget.idTerapeuta) {
      DateTime dia = DateTime.parse('${items[position].fechaConsulta}');
      print(dia);

      if (_consultas[dia] != null) {
        _consultas[dia].add(Card(
          child: Column(
            children: <Widget>[
              Text('${items[position].fechaConsulta}'),
              Text('${items[position].horaConsulta}'),
              Text('${items[position].nombre} ${items[position].apellidos}'),
            ],
          ),
        ));
      } else {
        _consultas[dia] = [
          Card(
            child: Column(
              children: <Widget>[
                Text('${items[position].fechaConsulta}'),
                Text('${items[position].horaConsulta}'),
                Text('${items[position].nombre} ${items[position].apellidos}'),
              ],
            ),
          )
        ];
      }

      
      print(_consultas);

      print('WE NO MAMES ESTA ES LA ID DE LA CONSULTA ${items[position].id}');

      print('MOTIVOS ${items[position].motivos}');
      print('PACIENTE: ${items[position].idPaciente} ${widget.idPaciente}');
      print('VFRNVJNVL ${items[position].nombre}');
      print('TERAPEUTA: ${items[position].idTerapeuta}');
      return Card(
        child: ListTile(
          title: Column(
            children: <Widget>[
              Text(
                '${items[position].nombre}',
                style: Theme.of(context).textTheme.headline,
              ),
            ],
          ),
          subtitle: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Text('Hora: '),
                Text('${items[position].horaConsulta}'),
              ]),
              Row(children: <Widget>[
                Text('Paciente: '),
                Text('${items[position].nombre} ${items[position].apellidos}'),
              ]),
              Row(children: <Widget>[
                Text('Motivo: '),
                Text('${items[position].motivos}'),
              ]),
              Divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: consultaPendiente(_diaActual,
                            items[position].fechaConsulta, position),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }

    
  }

/*-------------------------------------------------------ATRIBUTOS DE CALENDARIO---------------------------------------------*/
//Destruimos las variables vitales
  @override
  void dispose() {
    super.dispose();
    _onConsultaAddedSubscription.cancel();
    _onConsultaChangedSubscription.cancel();
  }

  List<Paciente> itemPaciente;
  List<Consultas> items;


//Metodo encargado de construir la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          //Creamos un calendario al principio
          TableCalendar(
    /*        onDaySelected: (date, consultas) {
              _selectedEvents = consultas;
              print(_selectedEvents);
            },*/
            events: _consultas,
            locale: 'es_MX',
            calendarController: _calendarController,
            calendarStyle: CalendarStyle(
                todayColor: Colors.orange, 
                selectedColor: Colors.teal[500]),
          ),
          Container(
            color: Colors.teal[300],
            
            width: 350.0,
            height: 40.0,
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              title: Text(
                'Consultas Globales',
                textAlign: TextAlign.center,
                  style: TextStyle(

                    color: Colors.white,

                  ),
              ),
            ),
          ),
         /* ..._selectedEvents.map((event) => Container(
                child: event,
              )),*/
          
                  
              Expanded(
              child: buildStream()
              ),
          
            
            

        ],
      ),
      /*
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed:  _showAddDialog,
        ),*/
    );
  }

//Metodo que deifnira el contenido segun el estado de los datos, ya sea si 
//No hay datos 
//No hay conexion
//Conexion baja
  Widget buildStream(){
    return StreamBuilder(
      stream: consultasReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){


        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
         //Si todo sale bien la app dara la lista de consultas 
          return  ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, position) {
                  return _filter(context, position);
                });
        }else{
        //Si hay errores regresamosun mensaje de error
          return Stack(
                      children:<Widget>[ 
                      
                        Center(

            
              child:ListView(
                            children:<Widget> [Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                              children:<Widget>[

                          Text( 'No se ha conectado a una red',
                          style: TextStyle(
                            color: Colors.red
                          ),),


                          Text( 'Favor de conectarse y reiniciar la aplicacion',
                          style: TextStyle(
                            color: Colors.grey
                          ), ),
                          Divider(
                            height: 30.0,
                            color: Colors.white
                          ),
                        Icon(
                          Icons.signal_wifi_off,
                          color: Colors.grey,
                          size: 100.0,
                         ),          
                     
                      _progresoCircular(),

                      
                  
                  ]
                ),]
              )
            ),
             ]
          );
          
          
        }
      }
      );}

  /*------------------METODOS PARA LA BASE DE DATOS QUE REALIZAN EL CRUD ------------------*/

  void _onConsultasAdded(Event event) {
    setState(() {
      items.add(new Consultas.fromSnapshot(event.snapshot));
    });
  }

  void _onConsultasUpdate(Event event) {
    var oldConsultasValue =
        items.singleWhere((consultas) => consultas.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldConsultasValue)] =
          new Consultas.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToConsultas(BuildContext context, Consultas consultas) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResConsultas(
            consultas: consultas,
          ),
        ));
  }


//Metodo que definira el estado de la consulta
  Widget consultaPendiente(DateTime ahora, String diaConsultaT, position) {
    DateTime valorDia = DateTime.parse(diaConsultaT);
    dynamic estorboDia = ahora.day < 10 ? 0 : '';
    dynamic estorboMes = ahora.month < 10 ? 0 : '';
    String fechaFormato =
        "${ahora.year}-$estorboMes${ahora.month}-$estorboDia${ahora.day}";
    print('$fechaFormato');
    print('$diaConsultaT');

    if (diaConsultaT == fechaFormato) {
      print('SI SE CUMPLE');
      return estado(position, 'Consulta del dia ', Colors.green);
    } else {
      if (
          valorDia.year > ahora.year ||
          valorDia.day < ahora.day &&
          valorDia.month < ahora.month &&
          valorDia.year > ahora.year || 

          valorDia.day < ahora.day &&
          valorDia.month > ahora.month &&
          valorDia.year > ahora.year ||

          valorDia.day > ahora.day &&
          valorDia.month > ahora.month &&
          valorDia.year > ahora.year ||

          valorDia.day > ahora.day &&
          valorDia.month == ahora.month &&
          valorDia.year == ahora.year ||

          valorDia.day == ahora.day &&
          valorDia.month > ahora.month &&
          valorDia.year == ahora.year ||

          valorDia.day == ahora.day &&
          valorDia.month == ahora.month &&
          valorDia.year > ahora.year ||

          valorDia.day < ahora.day &&
          valorDia.month < ahora.month &&
          valorDia.year > ahora.year ||

          valorDia.day < ahora.day &&
          valorDia.month < ahora.month &&
          valorDia.year > ahora.year ||
          
          valorDia.day < ahora.day &&
          valorDia.month > ahora.month &&
          valorDia.year == ahora.year
          ) {
        return estado(position, 'Consulta Pendiente', Colors.blue);
      } else {
        print('No SE CUMPLE');
        return estado(position, 'Consulta Pasada', Colors.red);
      }
    }
  }

  //Diseño del icono de estado 

  Widget estado(int position, String estado, Color color) {
    return Row(
      children: <Widget>[
        CircleAvatar(backgroundColor: color),
        VerticalDivider(
          width: 100.0,
        ),
        Column(
          children: <Widget>[
            Text(
              estado,
              style: TextStyle(
                color: color,
              ),
            ),
            Text(
              '${items[position].fechaConsulta}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }




}
