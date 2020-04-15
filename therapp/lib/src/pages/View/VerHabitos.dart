import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Habitos.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';
/*METODO QUE NOS MOSTRARA UNA LISTA DE HABITOS DEL PACIENTE */
class VerHabitos extends StatefulWidget {
  final Habitos habitos;
  final String pacienteId;
  VerHabitos({Key key, this.habitos, this.pacienteId}) : super(key: key);

  @override
  _VerHabitosState createState() => _VerHabitosState();
}
//METODO DE BASE DE DATOS
final habitosReference = FirebaseDatabase.instance.reference().child('habitos');

class _VerHabitosState extends State<VerHabitos> {
  List<Habitos> items;
  StreamSubscription<Event> _onHabitosAddedSubscription;
  StreamSubscription<Event> _onHabitosChangedSubscription;
//VARIABLES INICIALES 
  @override
  void initState() {
    super.initState();
    items = new List();
    _onHabitosAddedSubscription =
        habitosReference.onChildAdded.listen(_onHabitosAdded);
    _onHabitosChangedSubscription =
        habitosReference.onChildChanged.listen(_onHabitosUpdate);
  }
//DESTRUCCION DE VARIABLES ESENCIALES
  @override
  void dispose() {
    super.dispose();
    _onHabitosAddedSubscription.cancel();
    _onHabitosChangedSubscription.cancel();
  }
//METODO PARA DIBUJAR LA PANTALLA INDICADA
  @override
  Widget build(BuildContext context) {
    return buildStream();
  }

/*------------------------------------BACKEND Y MANEJO DEL CRUD FIREBASE----------------------------------------*/
  void _onHabitosAdded(Event event) {
    setState(() {
      items.add(new Habitos.fromSnapshot(event.snapshot));
    });
  }

  void _onHabitosUpdate(Event event) {
    var oldHabitosValue =
        items.singleWhere((habitos) => habitos.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldHabitosValue)] =
          new Habitos.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToHabitos(BuildContext context, Habitos habitos) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ResHabitos(habitos: habitos)));
  }

  void _createNewHabitos(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResHabitos(
                  habitos: Habitos(null, '', '', widget.pacienteId),
                )));
  }

  /*-----FRONTEDN CON FILTROS DE DATOS -----*/

  Widget _filter(BuildContext context, int position) {
    if (items[position].paciente == widget.pacienteId) {
      print('${items[position].id}');

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
//FORMATO INDVIDUAL DE CADA ITEM
  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          Divider(),
          _lista(items[position].habitosAlimenticios, context, position,
              'Habito Alimenticio'),
          Divider(),
          _lista(items[position].habitosHigiene, context, position,
              'Habito de Higiene'),
          Divider(),
          
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _navigateToHabitos(context, items[position]),
                
                )
            ],
          )
        ],
      ),
    );
  }
//METODO PARA DAR FORMATO A LA LISTA DE CADA ITEM
  Widget _lista(
      String variable, BuildContext context, int position, String subtitulo) {
    return ListTile(
      title: Text(
        '$variable',
        style: Theme.of(context).textTheme.headline,
      ),
      subtitle: Text('$subtitulo'),
     
      /* 
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$variable'),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToHabitos(context, items[position]))
        ],
      ),*/
    );
  }

   //METODO PARA DEFINIR UNA PANTALLA A MOSTRAR SEGUN LA CONECTIVIDAD A INTERNET 
  Widget buildStream(){
    return StreamBuilder(
      stream: habitosReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
          
          return   Scaffold(
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          }),
      floatingActionButton:
          FloatingActionButton(onPressed: () => _createNewHabitos(context),
          backgroundColor: Colors.orange,
          child: Icon(Icons.add_alarm),
          ),
          
    );
        }else{
        
          return Center(
          
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
                       )          
                  
                   

                    
                
                ]
              ),]
            )
          );

          
        }
      }
      );}
}
