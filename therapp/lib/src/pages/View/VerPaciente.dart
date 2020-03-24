import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/Habitos.dart';

import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/SignosVitales.dart';
import 'package:therapp/src/models/consultas.dart';
import 'package:therapp/src/pages/Register/RegistrarHabitos.dart';

import 'package:therapp/src/pages/View/VerAntecedentesFamiliares.dart';
import 'package:therapp/src/pages/View/VerAntecedentesNoPatologicos.dart';
import 'package:therapp/src/pages/View/VerAntecedentesPatologicos.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerHabitos.dart';
import 'package:therapp/src/pages/View/verSignosVitales.dart';

class VerPaciente extends StatefulWidget {
  final Paciente paciente;
  VerPaciente({Key key, this.paciente}) : super(key: key);

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
      length: 7,
      child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolling) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Contenido'),
                ),
                backgroundColor: Colors.amber,
                expandedHeight: 200,
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(TabBar(tabs: [
                  Tab(
                      icon: Icon(
                    Icons.ac_unit,
                    color: Colors.black,
                  )),
                  Tab(
                    icon: Icon(Icons.ac_unit, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit, color: Colors.black),
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit, color: Colors.black),
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
                              width: 20.0,
                              height: 90.0,
                            ),
                            Text("${widget.paciente.nombre}"),
                            Divider(),
                            Text("${widget.paciente.apellidos}"),
                            Divider(),
                            Text("${widget.paciente.edad}"),
                            Divider(),
                            Text("${widget.paciente.ocupacion}"),
                            Divider(),
                            Text("${widget.paciente.sexo}"),
                            Divider(),
                            Text("${widget.paciente.id}"),
                            Divider(),
                            FlatButton(
                              child: Text('hABITOS'),
                              onPressed: () {
                                _navigateToSignos(context);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              VerSignosVitales(
                pacienteId: widget.paciente.id,
              ),
              VerHabitos(
                pacienteId: widget.paciente.id,
              ),
              VerConsultas(
                idPaciente: widget.paciente.id,
              ),
              VerAntecPatologicos(
                pacienteId: widget.paciente.id,
              ),
              VerAntecNoPatologico(
                pacienteId: widget.paciente.id,
              ),
              VerAntecFamiliar(idPaciente: widget.paciente.id),
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
