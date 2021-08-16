import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/pages/Register/RegistrarSignosVitales.dart';
import 'package:therapp/src/pages/View/verSignosVitales.dart';


/*ESTA CLASE MOSTRARA LA LISTA DE SIGNOS VITALES BASANDOSE EN LAS FECHAS DE REGISTRO DE CADA PACIENTE*/
class ListaSignosVitales extends StatefulWidget {
  final SignosVitales signosVitales;
  final String pacienteId;
  ListaSignosVitales({Key key, this.signosVitales, this.pacienteId})
      : super(key: key);

  @override
  _ListaSignosVitalesState createState() => _ListaSignosVitalesState();
}
//METODO DE LA BASE DE DAROS 
final signosReference =
    FirebaseDatabase.instance.reference().child('signos_vitales');

class _ListaSignosVitalesState extends State<ListaSignosVitales> {
  StreamSubscription<Event> _onSignosAddedSubscription;
  StreamSubscription<Event> _onSignosChangedSubscription;

bool _cargando = true;
//VARIABLES AL INICIAR LA PANTALLA
  @override
  void initState() {
    super.initState();
    items = new List();
    _onSignosAddedSubscription =
        signosReference.onChildAdded.listen(_onSignosAdded);
    _onSignosChangedSubscription =
        signosReference.onChildChanged.listen(_onSignosUpdate);
  }
//DESTRUCCION DE VARIABLES VITALES
  @override
  void dispose() {
    super.dispose();
    _onSignosAddedSubscription.cancel();
    _onSignosChangedSubscription.cancel();
  }
//CREARCION DE ARREGLO PARA GUARDAR LOS DATOS 
  List<SignosVitales> items;
  @override
  Widget build(BuildContext context) {
    return buildStream();
   
    
  }

  
//Cronometro para el manejo de la caga de datos 
  Future<Timer> startTime() async {
    var _duration = Duration(seconds: 5);
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

 
/*-----------------------------------------METODOS PARA EL MANEJO DE CRUD DE CADA REGISTRO*/

  void _onSignosAdded(Event event) {
    setState(() {
      items.add(new SignosVitales.fromSnapshot(event.snapshot));
    });
  }

  void _onSignosUpdate(Event event) {
    var oldSignosValue = items
        .singleWhere((signosVitales) => signosVitales.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldSignosValue)] =
          new SignosVitales.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToSignos(
      BuildContext context, SignosVitales signosVitales) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistroSignosVitales(
            signosVitales: signosVitales,
          ),
        ));
  }

  void _createNewSignosVitales(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistroSignosVitales(
                  signosVitales: SignosVitales(
                      null, '', '', '', '', widget.pacienteId, '', ''),
                )));
  }

  void _navigateToSignosVitales(
      BuildContext context,
      SignosVitales signosVitales,
      String idPaciente,
      String fechaSignos) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerSignosVitales(
                  signosVitales: signosVitales,
                  pacienteId: idPaciente,
                  fechasignoVital: fechaSignos,
                )));
  }
//------------------------METODO QUE FILTRARA LOS DATOS DE LA TABLA Y LOS DIBUJARA CON UNA LISTA 
  Widget _filter(BuildContext context, int position) {
    if (items[position].paciente == widget.pacienteId) {
      print('SIGNOS VITALES${items[position].id}');

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
//FORMATO PARA CADA VISTA DEL REGISTROS
  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          Divider(),
          _lista(items[position].fechaSignos, context, position, items[position].hora),
        ],
      ),
    );
  }
//FORMATO DEL CONETNIDO 
  Widget _lista(
      String variable, BuildContext context, int position, String subtitulo) {
    return ListTile(
        title: Row(
          children: <Widget>[
            Text(
              'Fecha: $variable',
              style: Theme.of(context).textTheme.headline,
            ),
            VerticalDivider(
              width: 30.0,
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _navigateToSignos(context, items[position]),
                
                )
          ],
        ),
        subtitle: Text('Hora: $subtitulo'),
        onTap: () => _navigateToSignosVitales(context, items[position],
            items[position].paciente, items[position].fechaSignos));

    /* Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          
          
        ],
      ),*/
  }
//FORMATO DE LA LISTA EN PANTALLA 
  Widget estiloLista(String titulo, String subtitulo, BuildContext context) {
    return Row(
      children: <Widget>[
        ListTile(
          title: Text(
            '$titulo',
            style: Theme.of(context).textTheme.headline,
          ),
          subtitle: Text('$subtitulo'),
        ),
      ],
    );
  }

//METODO QUE NOS MOSTRARAR EL CONTENIDO SEGUN LA CONECTIVIDAD Y VITALIDAD DE LA BASE DE DATOS 
  Widget buildStream(){
    return StreamBuilder(
      stream: signosVitalesReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
        if(snap.hasData && !snap.hasError ){
          
          return  Scaffold(
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewSignosVitales(context),
          backgroundColor: Colors.orange,
          child: Icon(Icons.add_alert),
          ),);
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
                       ) ,         
                  _progresoCircular()
                   

                    
                
                ]
              ),]
            )
          );

          
        }
      }
      );}



}
