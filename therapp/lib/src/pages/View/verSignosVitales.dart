import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/pages/Register/RegistrarSignosVitales.dart';

class VerSignosVitales extends StatefulWidget {
  final String fechasignoVital;
  final SignosVitales signosVitales;
  final String pacienteId;

  VerSignosVitales({Key key, this.signosVitales, this.pacienteId,this.fechasignoVital})
      : super(key: key);

  @override
  _VerSignosVitalesState createState() => _VerSignosVitalesState();
}

final signosReference =
    FirebaseDatabase.instance.reference().child('signos_vitales');

class _VerSignosVitalesState extends State<VerSignosVitales> {
  StreamSubscription<Event> _onSignosAddedSubscription;
  StreamSubscription<Event> _onSignosChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onSignosAddedSubscription =
        signosReference.onChildAdded.listen(_onSignosAdded);
    _onSignosChangedSubscription =
        signosReference.onChildChanged.listen(_onSignosUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _onSignosAddedSubscription.cancel();
    _onSignosChangedSubscription.cancel();
  }

  List<SignosVitales> items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, position) {
              return _filter(context, position);
            }),
            
            floatingActionButton: FloatingActionButton(onPressed: ()=>_createNewSignosVitales(context)),
            );
  }

  /*------------------------------------BACKEND----------------------------------------*/
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
                  signosVitales:
                      SignosVitales(null, '', '', 0, '', widget.pacienteId,'',''),
                )));
  }

  Widget _filter(BuildContext context, int position) {
    if (items[position].fechaSignos == widget.fechasignoVital&&items[position].paciente==widget.pacienteId) {
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

  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          Divider(),
          _lista(items[position].fc, context, position,'Frecuencia Cardiaca'),
          Divider(),
          _lista(items[position].fr, context, position,'Frecuencia Respiratoria'),
          Divider(),
          _lista(items[position].peso.toString(), context, position,'Peso'),
          Divider(),
          _lista(items[position].talla, context, position,'Talla'),
           Divider(),
          _lista(items[position].fechaSignos, context, position,'Fecha'),
          Divider(),
          _lista(items[position].hora, context, position,'Hora'),
          
        ],
      ),
    );
  }

  Widget _lista(String variable, BuildContext context, int position,String subtitulo) {
    return ListTile(
      title: Text('$variable',style: Theme.of(context).textTheme.headline,),
      subtitle: Text('$subtitulo'),
      
      
     /* Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToSignos(context, items[position]))
        ],
      ),*/
    );
  }




     Widget estiloLista(String titulo, String subtitulo,BuildContext context){
    return ListTile(
      title: Text('$titulo',
      style: Theme.of(context).textTheme.headline,
      ),
      subtitle: Text('$subtitulo'),
    );  
  }




}
