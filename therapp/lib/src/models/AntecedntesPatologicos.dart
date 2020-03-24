import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AntecedentesPatologicos {
  String _id;
  String _enfermedad;
  String _idPaciente;

  AntecedentesPatologicos(this._id, this._enfermedad, this._idPaciente);

  AntecedentesPatologicos.map(dynamic obj) {
    this._enfermedad = obj['enfermedad'];
    this._idPaciente = obj['paciente'];
  }

  String get id => _id;
  String get enfermedad => _enfermedad;
  String get idpaciente => _idPaciente;

  AntecedentesPatologicos.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _enfermedad = snapshot.value['enfermedad'];
    _idPaciente = snapshot.value['paciente'];
  }
}
