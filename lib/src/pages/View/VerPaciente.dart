import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/UI/estadoFlexible.dart';
import 'package:therapp/src/UI/titulo.dart';
import 'package:therapp/src/models/Habitos.dart';

import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';
import 'package:therapp/src/pages/Register/RegistrarPaciente.dart';
import 'package:therapp/src/pages/Register/RegistrarSignosVitales.dart';
import 'package:therapp/src/pages/View/ListaConsultas.dart';
import 'package:therapp/src/pages/View/ListaSignosVitales.dart';

import 'package:therapp/src/pages/View/VerAntecedentesNoPatologicos.dart';
import 'package:therapp/src/pages/View/VerAntecedentesPatologicos.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerHabitos.dart';
import 'package:therapp/src/pages/View/verSignosVitales.dart';

/*METODO QUE SOLO MOSTRARA LOS DATOS DEL PACIENTE */
class VerPaciente extends StatefulWidget {
  final Paciente paciente;
  final String idTerapeuta;
  VerPaciente({Key key, this.paciente, this.idTerapeuta}) : super(key: key);

  @override
  _VerPacienteState createState() => _VerPacienteState();
}

//METODO DE BASE DE DATOS 
final pacienteReference =
    FirebaseDatabase.instance.reference().child('paciente');

class _VerPacienteState extends State<VerPaciente> {
  //VARIABLE INICIALES
  Consultas consultas;

  List<Paciente> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
//METODOS PARA DIBUJAR LA PANTALLA 
  @override
  Widget build(BuildContext context) {
    String nombre = widget.paciente.nombre;
    String apellidos = widget.paciente.apellidos;

    return Scaffold(
        body: DefaultTabController(
      length: 6,
      child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolling) {
            return <Widget>[
              SliverAppBar(

                backgroundColor: Colors.teal[500],
                elevation: 0.0,
                title: Titulo(
                  nombre: nombre,
                  apellidos: apellidos,
                ),
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: EspacioFlexible(
                      imagen: widget.paciente.imagenPaciente == ''
                          ? null
                          : widget.paciente.imagenPaciente,
                      sexo: widget.paciente.sexo,
                      edad: widget.paciente.edad.toString()),
                  centerTitle: true,
                ),
                expandedHeight: 200,
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 1.0,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    isScrollable: true,
                    //ARREGLO DEL TOOLBAR MENU
                    tabs: [
                      Tab(
                        text: 'Ficha Personal',
                      ),
                      Tab(
                        text: 'Signos Vitales',
                      ),
                      Tab(
                        text: 'Habitos',
                      ),
                      Tab(
                        text: 'Consultas',
                      ),
                      Tab(
                        text: 'Antecedentes Patologicos',
                      ),
                      Tab(
                        text: 'Antecedentes No Patologicos',
                      ),
                    ])),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
            buildStream(),
              ListaSignosVitales(
                pacienteId: widget.paciente.id,
              ),
              VerHabitos(
                pacienteId: widget.paciente.id,
              ),
              ListaConsultas(
                idPaciente: widget.paciente.id,
                idTerapeuta: widget.idTerapeuta,
                nombrePaciente: widget.paciente.nombre,
                apellidosPaciente: widget.paciente.apellidos,
              ),
              VerAntecPatologicos(
                pacienteId: widget.paciente.id,
              ),
              VerAntecNoPatologico(
                pacienteId: widget.paciente.id,
              ),
            ],
          )),
    ),
    
    
    );
  }


/*----------------------------METODOS Y CONTROL DE CRUD FIREBASE ---------------------------------------*/
  void _navigateToHabitos(BuildContext context, Habitos habitos) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerHabitos(
                habitos: habitos,
                pacienteId: widget.paciente.id,
              )),
    );
  }

  void _navigateToSignos(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerSignosVitales(
                pacienteId: widget.paciente.id,
              )),
    );
  }

  Widget estiloLista(String titulo, String subtitulo, BuildContext context, Paciente paciente) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(
            '$titulo',
            style: Theme.of(context).textTheme.headline,
          ),
         
          
        ],

      ),
      subtitle: Text('$subtitulo'),
    );
  }

 void _changePacienteInformation(
      BuildContext context, Paciente paciente) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrarPaciente(
                  paciente: paciente,
                  userId: widget.idTerapeuta,
                  app: true,
                )));
  }

   //----------------------METODO PARA DEFINIR UNA PANTALLA A MOSTRAR SEGUN LA CONECTIVIDAD A INTERNET -------------------------------------------
  Widget buildStream(){
    return StreamBuilder(
      stream: pacienteReference.onValue ,
      builder:(BuildContext context, AsyncSnapshot<dynamic> snap ){
        if(snap.hasData && !snap.hasError && snap.data.snapshot.value != null){
          
          return    Scaffold(
                      body: ListView(
                  children: <Widget>[
                    Container(
                      child: Card(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              estiloLista('${widget.paciente.nombre}',
                                  'Nombre del Paciente', context, widget.paciente),
                              Divider(),
                              estiloLista("${widget.paciente.apellidos}",
                                  'Apellidos', context,  widget.paciente),
                              Divider(),
                              estiloLista("${widget.paciente.nacimiento}",
                                  'Fecha de Nacimiento', context,  widget.paciente),
                              Divider(),
                              estiloLista(
                                  "${widget.paciente.edad}", 'Edad', context,  widget.paciente),
                              Divider(),
                              estiloLista("${widget.paciente.ocupacion}",
                                  'Ocupacion', context,  widget.paciente),
                              Divider(),
                              estiloLista(
                                  "${widget.paciente.sexo}", 'Sexo', context,  widget.paciente),
                              
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.edit),
                  onPressed: ()=> _changePacienteInformation(context, widget.paciente)
                  ),
          );
        }else{
        
          return  Center(
          
            child:Stack(
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
                      Icon(
                        Icons.signal_wifi_off,
                        color: Colors.grey,
                          size: 100.0,
                       ),

                             
                  
                   

                    
                
                ]
              ),
       
              
              ]
            )
          );

          
        }
      }
      );
      }

}
//METODO PARA CONTROLAR EL EL TOOLBAR PRINCIPAL 
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.teal[500],
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
