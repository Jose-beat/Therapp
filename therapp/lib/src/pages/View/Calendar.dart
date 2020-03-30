import 'dart:async';
import 'package:flutter/material.dart';


import 'package:firebase_database/firebase_database.dart';


import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';


class ConsultasActuales extends StatefulWidget {
   final String idTerapeuta;
  final String idPaciente;
  final Consultas consultas;
  ConsultasActuales({Key key, this.idTerapeuta, this.idPaciente, this.consultas}) : super(key: key);

  @override
  _ConsultasActualesState createState() => _ConsultasActualesState();
}

final consultasReference = FirebaseDatabase.instance.reference().child('Consultas');
 

class _ConsultasActualesState extends State<ConsultasActuales> {
/*-------------------------------------------------------ATRIBUTOS DE BASE DE DATOS---------------------------------------------*/
  StreamSubscription<Event> _onConsultaAddedSubscription;
  StreamSubscription<Event> _onConsultaChangedSubscription;


 dynamic _filter(BuildContext context, int position) {

    if (items[position].idTerapeuta == widget.idTerapeuta) {
     
      print('WE NO MAMES ESTA ES LA ID DE LA CONSULTA ${items[position].id}');
      print('MOTIVOS ${items[position].motivos}');
      print('PACIENTE: ${items[position].idPaciente} ${widget.idPaciente}');
      print('TERAPEUTA: ${items[position].idTerapeuta}');

       
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }


  }



/*-------------------------------------------------------ATRIBUTOS DE CALENDARIO---------------------------------------------*/
 



  @override
  void initState() {
 
  
    super.initState();
    items = new List();
    _onConsultaAddedSubscription =
        consultasReference.onChildAdded.listen(_onConsultasAdded);
    _onConsultaChangedSubscription =
        consultasReference.onChildChanged.listen(_onConsultasUpdate);
        
  }

  @override
  void dispose() {
    super.dispose();
    _onConsultaAddedSubscription.cancel();
    _onConsultaChangedSubscription.cancel();
  
  }

  List<Consultas> items;

  



  @override
  Widget build(BuildContext context) {
        
     return Scaffold(
        body: Container(

        ),
     );

      
  }

  

  
 
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
}





