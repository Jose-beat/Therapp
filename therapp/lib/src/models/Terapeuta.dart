import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
/*clase para manejo de modelos que usaremos para realizar CRUD en cada entidad*/
class Terapeuta {
    //Atributos de nuestro modelo
  String _id;
  String _nombre;
  String _apellidos;
  String _nacimiento;
  String _cedula;
  String _especialidad;
  String _clinica;
  String _telefono;
  String _email;
  String _imagen;
//contructor para el acceso en demas clases 
  Terapeuta(
      this._id,
      this._nombre,
      this._apellidos,
      this._nacimiento,
      this._clinica,
      this._email,
      this._especialidad,
      this._telefono,
      this._cedula,
      this._imagen);
//Mapeo de cada elemento en la columnba indicada 
  Terapeuta.map(dynamic obj) {
    this._nombre = obj['nombre'];
    this._apellidos = obj['apellidos'];
    this._nacimiento = obj['nacimiento'];
    this._clinica = obj['clinica'];
    this._cedula = obj['cedula'];
    this._especialidad = obj['especialidad'];
    this._telefono = obj['telefono'];
    this._email = obj['email'];
    this._imagen = obj['imagen'];
  }
//metodo get para acceso en otras clases 
  String get id => _id;
  String get nombre => _nombre;
  String get apellidos => _apellidos;
  String get nacimiento => _nacimiento;
  String get cedula => _cedula;
  String get clinica => _clinica;
  String get especialidad => _especialidad;
  String get telefono => _telefono;
  String get email => _email;
  String get imagen => _imagen;
//ESCRITURA DE DATOS EN EL MODELO Y CREACION DE LA TABLA 
  Terapeuta.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _nombre = snapshot.value['nombre'];
    _apellidos = snapshot.value['apellidos'];
    _nacimiento = snapshot.value['nacimiento'];
    _cedula = snapshot.value['cedula'];
    _clinica = snapshot.value['clinica'];
    _especialidad = snapshot.value['especialidad'];
    _telefono = snapshot.value['telefono'];
    _email = snapshot.value['email'];
    _imagen = snapshot.value['imagen'];
  }
}
