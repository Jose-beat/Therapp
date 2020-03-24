import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AntecedentesNoPatologicos {
  String _id;
  String _enfermedad;
  String _idPaciente;

  AntecedentesNoPatologicos(this._id, this._enfermedad, this._idPaciente);

  AntecedentesNoPatologicos.map(dynamic obj) {
    this._enfermedad = obj['enfermedad'];
    this._idPaciente = obj['paciente'];
  }

  String get id => _id;
  String get enfermedad => _enfermedad;
  String get idpaciente => _idPaciente;

  AntecedentesNoPatologicos.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _enfermedad = snapshot.value['enfermedad'];
    _idPaciente = snapshot.value['paciente'];
  }
}
