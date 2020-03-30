import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Habitos.dart';

import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';
import 'package:therapp/src/pages/View/ListaConsultas.dart';
import 'package:therapp/src/pages/View/ListaSignosVitales.dart';


import 'package:therapp/src/pages/View/VerAntecedentesNoPatologicos.dart';
import 'package:therapp/src/pages/View/VerAntecedentesPatologicos.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerHabitos.dart';
import 'package:therapp/src/pages/View/verSignosVitales.dart';

class VerPaciente extends StatefulWidget {
  final Paciente paciente;
  final String idTerapeuta;
  VerPaciente({Key key, this.paciente, this.idTerapeuta}) : super(key: key);

  @override
  _VerPacienteState createState() => _VerPacienteState();
}

final pacienteReference =
    FirebaseDatabase.instance.reference().child('paciente');

class _VerPacienteState extends State<VerPaciente> {
  Consultas consultas;

  List<Paciente> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 6,
      child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolling) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('${widget.paciente.nombre}\n ${widget.paciente.apellidos}',
                  style: TextStyle(
                    fontSize: 15.0
                  ),
                  ),
                ),
                backgroundColor: Colors.amber,
                expandedHeight: 200,
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(TabBar(tabs: [
                  Tab(
                      icon: Icon(
                    Icons.contact_mail,
                    color: Colors.black,
                  )),
                  Tab(
                    icon: Icon(Icons.favorite, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.find_in_page, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.flare, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.people_outline, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit, color: Colors.black),
                  ),
                  
                ])),
                pinned: false,
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    child: Card(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 10.0,
                              height: 20.0,
                            ),
                            estiloLista('${widget.paciente.nombre}','Nombre del Paciente', context),
                            Divider(),
                            estiloLista("${widget.paciente.apellidos}", 'Apellidos', context),
                            Divider(),
                            estiloLista("${widget.paciente.edad}", 'Edad', context),
                            Divider(),
                            estiloLista("${widget.paciente.ocupacion}", 'Ocupacion', context),
                            Divider(),
                            estiloLista("${widget.paciente.sexo}", 'Sexo', context),
                            Divider(),
                           estiloLista("${widget.paciente.id}", 'Identificacion', context),
                            Divider(),
                          
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListaSignosVitales(
                pacienteId: widget.paciente.id,
                
              ),
              VerHabitos(
                pacienteId: widget.paciente.id,
              ),
              ListaConsultas(
                idPaciente: widget.paciente.id,
                idTerapeuta: widget.idTerapeuta,
                
              ),
              VerAntecPatologicos(
                pacienteId: widget.paciente.id,
              ),
              VerAntecNoPatologico(
                pacienteId: widget.paciente.id,
              ),
            ],
          )),
    ));
  }

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


   Widget estiloLista(String titulo, String subtitulo,BuildContext context){
    return ListTile(
      title: Text('$titulo',
      style: Theme.of(context).textTheme.headline,
      ),
      subtitle: Text('$subtitulo'),
    );  
  }
}

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
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }


 



}
