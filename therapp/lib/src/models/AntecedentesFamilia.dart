import 'package:firebase_database/firebase_database.dart';

class AntecedentesFamiliares {
  String _id;
  bool _diabetes;
  bool _hipertension;
  bool _cancer;
  String _idpaciente;

  AntecedentesFamiliares(this._id, this._diabetes, this._hipertension,
      this._cancer, this._idpaciente);

  AntecedentesFamiliares.map(dynamic obj) {
    this._diabetes = obj['diabetes'];
    this._hipertension = obj['hipertension'];
    this._cancer = obj['cancer'];
    this._idpaciente = obj['paciente'];
  }

  String get id => _id;
  bool get diabetes => _diabetes;
  bool get hipertension => _hipertension;
  bool get cancer => _cancer;
  String get idpaciente => _idpaciente;

  AntecedentesFamiliares.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _diabetes = snapshot.value['diabetes'];
    _hipertension = snapshot.value['hipertension'];
    _cancer = snapshot.value['cancer'];
    _idpaciente = snapshot.value['paciente'];
  }
}
