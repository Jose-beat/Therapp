import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:therapp/src/models/Paciente.dart';

import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';

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

final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _ConsultasActualesState extends State<ConsultasActuales> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _consultas;
  TextEditingController _consultaController;
  List<dynamic> _selectedEvents;
  DateTime _diaActual = DateTime.now();
  SharedPreferences prefs;

/*-------------------------------------------------------ATRIBUTOS DE BASE DE DATOS---------------------------------------------*/
  StreamSubscription<Event> _onConsultaAddedSubscription;
  StreamSubscription<Event> _onConsultaChangedSubscription;

  @override
  void initState() {
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
              Text('${items[position].nombre} ${items[position].nombre}'),
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
                Text('${items[position].nombre} ${items[position].nombre}'),
              ],
            ),
          )
        ];
      }

      _selectedEvents = _consultas[dia];

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

  @override
  void dispose() {
    super.dispose();
    _onConsultaAddedSubscription.cancel();
    _onConsultaChangedSubscription.cancel();
  }

  List<Paciente> itemPaciente;
  List<Consultas> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TableCalendar(
            onDaySelected: (date, consultas) {
              _selectedEvents = consultas;
              print(_selectedEvents);
            },
            events: _consultas,
            locale: 'es_MX',
            calendarController: _calendarController,
            calendarStyle: CalendarStyle(
                todayColor: Colors.orange, selectedColor: Colors.teal[500]),
          ),
          Card(
            child: Text(
              'Consultas Globales',
                style: Theme.of(context).textTheme.headline,
            ),
          ),
         /* ..._selectedEvents.map((event) => Container(
                child: event,
              )),*/
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, position) {
                  return _filter(context, position);
                }),
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
/*
   _showAddDialog(){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _consultaController,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                if(_consultaController.text.isEmpty) return;
                setState(() {
                  if(_consultas[_calendarController.selectedDay]!=null){
                  _consultas[_calendarController.selectedDay].add(_consultaController.text);
                }
                else{
                  _consultas[_calendarController.selectedDay] = [_consultaController.text];
                }
                _consultaController.clear();
                Navigator.pop(context);
                });
                
              }, 
              child: Text('Save')
              )
          ],
        )
        );
    }*/

  /*------------------                       ------------------*/

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
      if (valorDia.day > ahora.day ||
          valorDia.month > ahora.month ||
          valorDia.year > ahora.year) {
        return estado(position, 'Consulta Pendiente', Colors.blue);
      } else {
        print('No SE CUMPLE');
        return estado(position, 'Consulta Pasada', Colors.red);
      }
    }
  }

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
