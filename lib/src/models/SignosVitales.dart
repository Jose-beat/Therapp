//import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
/*clase para manejo de modelos que usaremos para realizar CRUD en cada entidad*/
class SignosVitales {
    //Atributos de nuestro modelo
  String _id;
  String _fc;
  String _fr;
  String _peso;
  String _talla;
  String _idpaciente;
  String _fechaSignosVitales;
  String _hora;
//contructor para el acceso en demas clases 
  SignosVitales(this._id, this._fc, this._fr, this._peso, this._talla,
      this._idpaciente, this._fechaSignosVitales, this._hora);
//Mapeo de cada elemento en la columnba indicada 
  SignosVitales.map(dynamic obj) {
    this._fc = obj['frecuencia cardiaca'];
    this._fr = obj['frecuencia respiratoria'];
    this._peso = obj['peso'];
    this._talla = obj['talla'];
    this._fechaSignosVitales = obj['fecha'];
    this._hora = obj['hora'];
    this._idpaciente = obj['paciente'];
  }
//metodo get para acceso en otras clases 
  String get id => _id;
  String get fc => _fc;
  String get fr => _fr;
  String get peso => _peso;
  String get talla => _talla;
  String get fechaSignos => _fechaSignosVitales;
  String get hora => _hora;
  String get paciente => _idpaciente;
//ESCRITURA DE DATOS EN EL MODELO Y CREACION DE LA TABLA 
  SignosVitales.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _fc = snapshot.value['frecuencia cardiaca'];
    _fr = snapshot.value['frecuencia respiratoria'];
    _peso = snapshot.value['peso'];
    _talla = snapshot.value['talla'];
    _fechaSignosVitales = snapshot.value['fecha'];
    _hora = snapshot.value['hora'];
    _idpaciente = snapshot.value['paciente'];
  }
}
