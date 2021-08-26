//import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
/*clase para manejo de modelos que usaremos para realizar CRUD en cada entidad*/
class AntecedentesNoPatologicos {
  //Atributos de nuestro modelo
  String _id;
  String _enfermedad;
  String _idPaciente;
//contructor para el acceso en demas clases 
  AntecedentesNoPatologicos(this._id, this._enfermedad, this._idPaciente);
//Mapeo de cada elemento en la columnba indicada 
  AntecedentesNoPatologicos.map(dynamic obj) {
    this._enfermedad = obj['enfermedad'];
    this._idPaciente = obj['paciente'];
  }
//metodo get para acceso en otras clases 
  String get id => _id;
  String get enfermedad => _enfermedad;
  String get idpaciente => _idPaciente;
//ESCRITURA DE DATOS EN EL MODELO Y CREACION DE LA TABLA 
  AntecedentesNoPatologicos.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _enfermedad = snapshot.value['enfermedad'];
    _idPaciente = snapshot.value['paciente'];
  }
}
