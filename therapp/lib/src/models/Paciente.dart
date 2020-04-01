import 'package:firebase_database/firebase_database.dart';

class Paciente {
  String _id;
  String _nombre;
  String _apellidos;
  String _nacimiento;
  int _edad;
  String _ocupacion;
  String _sexo;
  String _terapeuta;

  Paciente(this._id, this._nombre, this._apellidos,this._nacimiento ,this._edad, this._ocupacion,
      this._sexo, this._terapeuta);

  Paciente.map(dynamic obj) {
    this._nombre = obj['nombre'];
    this._apellidos = obj['apellidos'];
    this._nacimiento = obj['nacimiento'];
    this._edad = obj['edad'];
    this._ocupacion = obj['ocupacion'];
    this._sexo = obj['sexo'];
    this._terapeuta = obj['terapeuta'];
  }

  String get id => _id;
  String get nombre => _nombre;
  String get apellidos => _apellidos;
  String get nacimiento => _nacimiento;
  int get edad => _edad;
  String get ocupacion => _ocupacion;
  String get sexo => _sexo;
  String get terapeuta => _terapeuta;

  Paciente.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _nombre = snapshot.value['nombre'];
    _apellidos = snapshot.value['apellidos'];
    _nacimiento = snapshot.value['nacimiento'];
    _edad = snapshot.value['edad'];
    _ocupacion = snapshot.value['ocupacion'];
    _sexo = snapshot.value['sexo'];
    _terapeuta = snapshot.value['terapeuta'];
  }
}
