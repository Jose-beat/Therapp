import 'package:firebase_database/firebase_database.dart';

class Consultas {
  String _id;
  String _motivo;
  String _idPaciente;

  Consultas(this._id, this._motivo, this._idPaciente);

  Consultas.map(dynamic obj) {
    this._motivo = obj['motivos_consulta'];
    this._idPaciente = obj['paciente'];
  }

  String get id => _id;
  String get motivos => _motivo;
  String get idPaciente => _idPaciente;

  Consultas.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _motivo = snapshot.value['motivos_consulta'];
    _idPaciente = snapshot.value['paciente'];
  }
}
