import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesFamilia.dart';

class ResAntecedentesFamiliares extends StatefulWidget {
  
  final AntecedentesFamiliares antecedentesFamiliares;
  ResAntecedentesFamiliares({Key key, this.antecedentesFamiliares}) : super(key: key);

  @override
  _ResAntecedentesFamiliaresState createState() => _ResAntecedentesFamiliaresState();
}
final antecedentesFamiliaresReference = FirebaseDatabase.instance.reference().child('antecedentes_familiares');
class _ResAntecedentesFamiliaresState extends State<ResAntecedentesFamiliares> {
  List<AntecedentesFamiliares>items;


  @override
  Widget build(BuildContext context) {
    return Container(
       
    );
  }
}