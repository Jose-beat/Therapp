import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Habitos {
  String _id;
  String _habitosAlimenticios;
  String _habitosHiginene;
  String _idpaciente;

  Habitos(this._id,this._habitosAlimenticios,this._habitosHiginene,this._idpaciente);

  Habitos.map(dynamic obj){
    this._habitosAlimenticios = obj['habitos_alimenticios'];
    this._habitosHiginene = obj['habitos_higiene'];
    this._idpaciente = obj['paciente'];
  }

  String get id => _id;
  String get habitosAlimenticios => _habitosAlimenticios;
  String get habitosHigiene => _habitosHiginene;
  String get paciente => _idpaciente;

  Habitos.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key;
    _habitosAlimenticios = snapshot.value['habitos_alimenticios'];
    _habitosHiginene = snapshot.value['habitos_higiene'];
    _idpaciente = snapshot.value['paciente'];
  }
}
