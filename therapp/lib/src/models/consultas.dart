import 'package:firebase_database/firebase_database.dart';

class Consultas {
  String _id;
  String _motivo;
  String _idPacinete;

  Consultas(this._id,this._motivo,this._idPacinete);

  Consultas.map(dynamic obj){
    this._motivo=obj['motivos_consulta'];
    this._idPacinete=obj['paciente'];

  }

  String get id => _id;
  String get motivos => _motivo;
  String get idPaciente => _idPacinete;

  Consultas.fromSnapshot(DataSnapshot snapshot){
    _id=snapshot.key;
    _motivo = snapshot.value['motivo'];
    _idPacinete = snapshot.value['paciente'];

  }


}