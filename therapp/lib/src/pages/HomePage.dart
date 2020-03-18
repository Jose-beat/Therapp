import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/Terapeuta.dart';
import 'package:therapp/src/pages/RegistrarPaciente.dart';
import 'package:therapp/src/pages/VerPaciente.dart';
import 'package:therapp/src/pages/VerTerapeuta.dart';
import 'package:therapp/src/providers/authentApp.dart';

class HomePage extends StatefulWidget {
    
    final BaseAuth auth;
    final VoidCallback loginCallback;
    final VoidCallback logoutCallback;
    final String userId;

  const HomePage({Key key, this.auth, this.loginCallback, this.userId, this.logoutCallback}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
final pacienteReference = FirebaseDatabase.instance.reference().child('paciente');

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
 
  List<Paciente> items;
  
  StreamSubscription<Event> _onPacienteAddedSubscription;
  StreamSubscription<Event> _onPacienteupdatedSubscription;
  
  @override
  void initState() { 
    super.initState();
    items = new List();
    _onPacienteAddedSubscription = pacienteReference.onChildAdded.listen(_onPacienteAdded);
    _onPacienteupdatedSubscription = pacienteReference.onChildChanged.listen(_onPacienteUpdated);
  }
  @override
  void dispose() { 
    
    super.dispose();
    _onPacienteAddedSubscription.cancel();
    _onPacienteupdatedSubscription.cancel();
  }

    signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  } 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(
          color: Colors.black
        ),
        actions: <Widget>[
          
          

          FlatButton(
            
            onPressed: signOut,

          child: Text('Cerrar Sesion')
          
          ),
          FlatButton(onPressed: (){
                    _createNewPaciente(context);
                  }, child:Text('crear paciente')),




          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.supervised_user_circle),
              radius: 20.0,
            ),
     
            padding: EdgeInsets.all(0.0),
            onPressed: (){
               Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>VerTerapeuta(userId: widget.userId,auth: widget.auth,logoutCallback: widget.logoutCallback,)));
            },
          ),

          
        ],
       
      ),


      body:  ListView.builder(
            itemCount: items.length,
            
            itemBuilder: (context, position ){
           
               return _filter(context, position);
              

              
            },

            
            
            ),
     
    );
  }

  
/*---------------------------METODOS PARA CREAR AL PÁCIENTE */

  void _createNewPaciente(BuildContext context) async {

    await Navigator.push(context,
      MaterialPageRoute(builder: (context)=> RegistrarPaciente(paciente: Paciente(null, '', '', '', '', '',widget.userId),userId:widget.userId,))
     );
  }

  void _navigateToPaciente(BuildContext context, Paciente paciente) async {
    await Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> VerPaciente(paciente: paciente))
    );
  }

  void _onPacienteAdded(Event event){
    setState(() {
      items.add(new Paciente.fromSnapshot(event.snapshot));
    });

  }
  void _onPacienteUpdated(Event event)  {
    var oldPacienteValue = items.singleWhere((paciente)=> paciente.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldPacienteValue)] = new Paciente.fromSnapshot(event.snapshot);
    });
  }
/*-------------------------------------METODOS TERAPEUTA--------------------------*/

void _navigateToTerapeuta(BuildContext context, String user) async {
  await Navigator.push(context, 
      MaterialPageRoute(builder: (context)=> VerTerapeuta(userId: user,))
    );
    print('jaja nkscbkjds${widget.userId}');
}

   






 Widget _filter(BuildContext context, int position){
   
    print("item :${items[position].id}");
   
  
    if(items[position].terapeuta==widget.userId){
               
                  print('${items[position].id}');
                  
              return Column(
                children: <Widget>[
                  Divider(
                    height: 7.0,
                  ),
                  Card(
                                      child: Row(
                      children: <Widget>[
                        
                        Expanded(child: ListTile(title: Text('${items[position].nombre}',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 21.0
                        ),
                        ),
                          subtitle: Text(
                            '${items[position].apellidos}',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 21.0,

                            ),
                          ),
                          leading: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.amberAccent,
                                radius: 17.0,
                                child: Text('${position + 1}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 21.0
                                ),
                                ),
                              )
                            ],
                          ),
                          onTap: ()=>_navigateToPaciente(context, items[position]),
          )
                        ),
                    /*  IconButton(
                      icon: Icon(Icons.delete, color: Colors.red,), 
                      onPressed: () => _deleteProduct(context, items[position],position)),*/
                
                       
                      ],
                    ),
                  ),
                 
                ],
              );
       
                
              }else{
                return Container(
                  width: 0.0,
                  height: 0.0,
                );
              }
  }



}
