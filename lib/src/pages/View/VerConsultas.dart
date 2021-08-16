import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';


/*ESTA CLASE MOSTRARA EL REGISTRO DE LAS CONSULTAS SELECCIONADAD SEGUN EL USUARIO*/
class VerConsultas extends StatefulWidget {
  final String fechaConsulta;
  final String idTerapeuta;
  final String idPaciente;
  final Consultas consultas;

  VerConsultas(
      {Key key,
      this.idPaciente,
      this.consultas,
      this.idTerapeuta,
      this.fechaConsulta})
      : super(key: key);

  @override
  _VerConsultasState createState() => _VerConsultasState();
}
//METODO DE BASE DE DATOS 
final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _VerConsultasState extends State<VerConsultas> {

  //VARIABLES INICALES 
  StreamSubscription<Event> _onConsultaAddedSubscription;
  StreamSubscription<Event> _onConsultaChangedSubscription;

//VARIABLES INCIALES 
  @override
  void initState() {
    super.initState();
    items = new List();
    _onConsultaAddedSubscription =
        consultasReference.onChildAdded.listen(_onConsultasAdded);
    _onConsultaChangedSubscription =
        consultasReference.onChildChanged.listen(_onConsultasUpdate);
  }
//DESTRUCCION DE METODOS ESCENCIALES
  @override
  void dispose() {
    super.dispose();
    _onConsultaAddedSubscription.cancel();
    _onConsultaChangedSubscription.cancel();
  }

  List<Consultas> items;

  //METODO DE CREACION DE LA PANTALLA 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Consultas')
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          }),
      
    );
  }

  /*------------------------------------BACKEND Y MANEJO DE BASE DE DATOS ----------------------------------------*/
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

  void _createNewConsultas(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResConsultas(
                  consultas: Consultas(null, '', widget.idPaciente,
                      widget.idTerapeuta, '', '', '', ''),
                )));
  }



  //METODOS DE FILTRO PARA LOS DATOS DE FIREBASE
  Widget _filter(BuildContext context, int position) {
    print('VE ESTE MENSAJE');

    if (items[position].idPaciente == widget.idPaciente &&
        items[position].fechaConsulta == widget.fechaConsulta &&
        items[position].horaConsulta == widget.consultas.horaConsulta
        ) {
      print('WE NO MAMES ESTA ES LA ID DE LA CONSULTA ${items[position].id}');
      print('MOTIVOS ${items[position].motivos}');
      print('NUKLITO ${items[position].nombre}');
      print('PACIENTE: ${items[position].idPaciente} ${widget.idPaciente}');

      return Column(
        children: <Widget>[_info(context, position)],
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  //METODO PARA DAR FORMATO A CADA ITEM

  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          Divider(),
          _lista(items[position].motivos, context, position,
              'Motivo de la Consulta'),
          _lista(items[position].fechaConsulta, context, position, 'Fecha'),
          _lista(items[position].horaConsulta, context, position, 'Hora'),
        ],
      ),
    );
  }

//METODO PARA DAR FORMATO A EL CONJUNTO DE ITEMS
  Widget _lista(
      String variable, BuildContext context, int position, String subtitulo) {
    return ListTile(
        title: Row(
          children: <Widget>[
            Text(
              '$variable',
              style: Theme.of(context).textTheme.headline,
            ),
          
          ],
        ),
        subtitle: Text('$subtitulo'));
  }
}
