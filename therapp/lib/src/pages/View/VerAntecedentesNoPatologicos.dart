import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesNoPatologicos.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';
import 'package:therapp/src/pages/Register/RegistrarAntecedentesNoPatologicos.dart';

class VerAntecNoPatologico extends StatefulWidget {
  final String pacienteId;
  final AntecedentesNoPatologicos antecedentesNoPatologicos;
  VerAntecNoPatologico(
      {Key key, this.pacienteId, this.antecedentesNoPatologicos})
      : super(key: key);

  @override
  _VerAntecNoPatologicoState createState() => _VerAntecNoPatologicoState();
}

final antecNoPatReference =
    FirebaseDatabase.instance.reference().child('antecedentes_no_patologicos');

class _VerAntecNoPatologicoState extends State<VerAntecNoPatologico> {
  StreamSubscription<Event> _onAntNoPatAddedSubscription;
  StreamSubscription<Event> _onAntNoPatChangedSubscription;
  List<AntecedentesNoPatologicos> items;
  @override
  void initState() {
    super.initState();
    items = new List();
    _onAntNoPatAddedSubscription =
        antecNoPatReference.onChildAdded.listen(_onAntNoPatAdded);
    _onAntNoPatChangedSubscription =
        antecNoPatReference.onChildChanged.listen(_onAntNoPatUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onAntNoPatAddedSubscription.cancel();
    _onAntNoPatChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return buildStream();
  }

  /*------------------------------------BACKEND----------------------------------------*/
  void _onAntNoPatAdded(Event event) {
    setState(() {
      items.add(new AntecedentesNoPatologicos.fromSnapshot(event.snapshot));
    });
  }

  void _onAntNoPatUpdate(Event event) {
    var oldAntNoPatValue = items.singleWhere((antecedentesNoPatologicos) =>
        antecedentesNoPatologicos.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldAntNoPatValue)] =
          new AntecedentesNoPatologicos.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToAntNoPat(BuildContext context,
      AntecedentesNoPatologicos antecedentesNoPatologicos) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResAntecedentesNoPatologicos(
                antecedentesNoPatologicos: antecedentesNoPatologicos,
              )),
    );
  }

  void _createNewAntecNoPatologico(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResAntecedentesNoPatologicos(
                  antecedentesNoPatologicos:
                      AntecedentesNoPatologicos(null, '', widget.pacienteId),
                )));
  }

  Widget _filter(BuildContext context, int position) {
    if (items[position].idpaciente == widget.pacienteId) {
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

  Widget _info(BuildContext context, int position) {
    return Card(
      child: Column(
        children: <Widget>[
          Divider(),
          _lista(items[position].enfermedad, context, position,
              'Antecedente no Patologico'),
        ],
      ),
    );
  }

  Widget _lista(
      String variable, BuildContext context, int position, String subtitulo) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$variable', style: Theme.of(context).textTheme.headline),
          VerticalDivider(
            width: 110.0,
          ),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _navigateToAntNoPat(context, items[position]))
        ],
      ),
      subtitle: Text('$subtitulo'),
    );
  }

  
  Widget buildStream(){
    return StreamBuilder(
      stream: antecNoPatReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
          
          return  Scaffold(
    
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return _filter(context, position);
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewAntecNoPatologico(context),
            backgroundColor: Colors.orange,
          child: Icon(Icons.person_add)
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
