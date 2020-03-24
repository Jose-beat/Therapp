import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SignosVitales {
  String _id;
  String _fc;
  String _fr;
  int _peso;
  String _talla;
  String _idpaciente;

  SignosVitales(
      this._id, this._fc, this._fr, this._peso, this._talla, this._idpaciente);

  SignosVitales.map(dynamic obj) {
    this._fc = obj['frecuencia cardiaca'];
    this._fr = obj['frecuencia respiratoria'];
    this._peso=obj['peso'];
    this._talla = obj['talla'];
    this._idpaciente = obj['paciente'];
  }

  String get id => _id;
  String get fc => _fc;
  String get fr => _fr;
  int get peso => _peso;
  String get talla => _talla;
  String get paciente => _idpaciente;

  SignosVitales.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _fc = snapshot.value['frecuencia cardiaca'];
    _fr = snapshot.value['frecuencia respiratoria'];
    _peso = snapshot.value['peso'];
    _talla = snapshot.value['talla'];
    _idpaciente = snapshot.value['paciente'];
  }
}
