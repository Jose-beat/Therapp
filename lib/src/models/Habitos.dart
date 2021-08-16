import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
/*clase para manejo de modelos que usaremos para realizar CRUD en cada entidad*/
class Habitos {
    //Atributos de nuestro modelo
  String _id;
  String _habitosAlimenticios;
  String _habitosHiginene;
  String _idpaciente;
//contructor para el acceso en demas clases 
  Habitos(this._id, this._habitosAlimenticios, this._habitosHiginene,
      this._idpaciente);
//Mapeo de cada elemento en la columnba indicada 
  Habitos.map(dynamic obj) {
    this._habitosAlimenticios = obj['habitos_alimenticios'];
    this._habitosHiginene = obj['habitos_higiene'];
    this._idpaciente = obj['paciente'];
  }
//metodo get para acceso en otras clases 
  String get id => _id;
  String get habitosAlimenticios => _habitosAlimenticios;
  String get habitosHigiene => _habitosHiginene;
  String get paciente => _idpaciente;
//ESCRITURA DE DATOS EN EL MODELO Y CREACION DE LA TABLA 
  Habitos.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _habitosAlimenticios = snapshot.value['habitos_alimenticios'];
    _habitosHiginene = snapshot.value['habitos_higiene'];
    _idpaciente = snapshot.value['paciente'];
  }
}
