import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarConsultas.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';


/*ESTA CLASE CREARA UNA LISTA GLOBAL DE CONSULTAS DEL TERAPEUTA*/
class ListaConsultas extends StatefulWidget {
  //VARIABLES INICIALES
  final String nombrePaciente;
  final String apellidosPaciente;
  final String idTerapeuta;
  final String idPaciente;
  final Consultas consultas;
  ListaConsultas(
      {Key key,
      this.idTerapeuta,
      this.idPaciente,
      this.consultas,
      this.nombrePaciente,
      this.apellidosPaciente})
      : super(key: key);

  @override
  _ListaConsultasState createState() => _ListaConsultasState();
}

//Metodo para el uso de la base de datos 
final consultasReference =
    FirebaseDatabase.instance.reference().child('Consultas');

class _ListaConsultasState extends State<ListaConsultas> {

  //Variables iniciales
  StreamSubscription<Event> _onConsultaAddedSubscription;
  StreamSubscription<Event> _onConsultaChangedSubscription;
//Variables iniciales al iniciar la app
  @override
  void initState() {
    super.initState();
    items = new List();
    _onConsultaAddedSubscription =
        consultasReference.onChildAdded.listen(_onConsultasAdded);
    _onConsultaChangedSubscription =
        consultasReference.onChildChanged.listen(_onConsultasUpdate);
  }
//Destruccion de metodo vitales
  @override
  void dispose() {
    super.dispose();
    _onConsultaAddedSubscription.cancel();
    _onConsultaChangedSubscription.cancel();
  }
//Lista basada en el contenido de la base de datos 
  List<Consultas> items;

  @override
  Widget build(BuildContext context) {
    return buildStream();
  }

/*--------------------------------///////METODOS PARA EL MANEJO DE LA BASE DE DATOS ////////////////////////////////---------------------------------------*/

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
                  consultas: Consultas(
                      null,
                      '',
                      widget.idPaciente,
                      widget.idTerapeuta,
                      '',
                      '',
                      widget.nombrePaciente,
                      widget.apellidosPaciente),
                )));
  }

  void _navigateToConsulta(BuildContext context, Consultas consultas,
      String idPaciente, String fechaConsulta, String idTerapeuta) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerConsultas(
                  idPaciente: idPaciente,
                  consultas: consultas,
                  idTerapeuta: idTerapeuta,
                  fechaConsulta: fechaConsulta,
                )));
  }

/*-----------------------------------------------------------------METODO QUE DIBUJARA LA LISTA GLOBAL DE CONSULTAS------////////////////////////////_-------------------------------------*/

  Widget _filter(BuildContext context, int position) {
    print('VE ESTE MENSAJE');

    if (items[position].idPaciente == widget.idPaciente) {
      print('WE NO MAMES ESTA ES LA ID DE LA CONSULTA ${items[position].id}');
      print('MOTIVOS ${items[position].motivos}');
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

  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          Divider(),
          _lista(items[position].fechaConsulta, context, position,
              items[position].motivos),
        ],
      ),
    );
  }

  Widget _lista(
      String variable, BuildContext context, int position, String subtitulo) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(
            '$variable',
            style: Theme.of(context).textTheme.headline,
          ),
          VerticalDivider(
            width: 110.0,
          ),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToConsultas(context, items[position]))
        ],
      ),
      subtitle: Text('$subtitulo'),
      onTap: () => _navigateToConsulta(
          context,
          items[position],
          items[position].idPaciente,
          items[position].fechaConsulta,
          items[position].idTerapeuta),
    );
  }



  
  Widget buildStream(){
    return StreamBuilder(
      stream: consultasReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
          
          return   Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, position) {
              return _filter(context, position);
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _createNewConsultas(context),
            backgroundColor: Colors.orange,
            child: Icon(Icons.add_comment),
            ));
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
