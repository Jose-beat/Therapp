import 'package:firebase_database/firebase_database.dart';

class Consultas {
  String _id;
  String _motivo;
  String _idPaciente;
  String _idterapeuta;
  String _fechaConsulta;
  

  Consultas(this._id, this._motivo, this._idPaciente,this._idterapeuta,this._fechaConsulta);

  Consultas.map(dynamic obj) {
    this._motivo = obj['motivos_consulta'];
    this._idPaciente = obj['paciente'];
    this._idterapeuta = obj['terapeuta'];
    this._fechaConsulta = obj['fecha'];
  }

  String get id => _id;
  String get motivos => _motivo;
  String get idPaciente => _idPaciente;
  String get idTerapeuta => _idterapeuta;
  String get fechaConsulta =>_fechaConsulta;

  Consultas.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _motivo = snapshot.value['motivos_consulta'];
    _idPaciente = snapshot.value['paciente'];
    _idterapeuta = snapshot.value['terapeuta'];
    _fechaConsulta = snapshot.value['fecha'];
  }
}
