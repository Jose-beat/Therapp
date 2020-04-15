import 'package:firebase_database/firebase_database.dart';
/*clase para manejo de modelos que usaremos para realizar CRUD en cada entidad*/
class Consultas {
    //Atributos de nuestro modelo
  String _id;
  String _motivo;
  String _idPaciente;
  String _nombrePaciente;
  String _apellidosPaciente;
  String _idterapeuta;
  String _fechaConsulta;
  String _hora;
  
//contructor para el acceso en demas clases 
  Consultas(this._id, this._motivo, this._idPaciente,this._idterapeuta,this._fechaConsulta, this._hora,this._nombrePaciente,this._apellidosPaciente);
//Mapeo de cada elemento en la columnba indicada 
  Consultas.map(dynamic obj) {
    this._motivo = obj['motivos_consulta'];
    this._nombrePaciente = obj['nombre_paciente'];
    this._apellidosPaciente = obj['apellidos_paciente'];
    this._idPaciente = obj['paciente'];
    this._idterapeuta = obj['terapeuta'];
    this._fechaConsulta = obj['fecha'];
    this._hora = obj['hora'];
  }
//metodo get para acceso en otras clases 
  String get id => _id;
  String get motivos => _motivo;
  String get idPaciente => _idPaciente;
  String get nombre => _nombrePaciente;
  String get apellidos => _apellidosPaciente;
  String get idTerapeuta => _idterapeuta;
  String get fechaConsulta =>_fechaConsulta;
  String get horaConsulta =>_hora;
//ESCRITURA DE DATOS EN EL MODELO Y CREACION DE LA TABLA 
  Consultas.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _motivo = snapshot.value['motivos_consulta'];
    _idPaciente = snapshot.value['paciente'];
    _nombrePaciente = snapshot.value['nombre_paciente'];
    _apellidosPaciente = snapshot.value['apellidos_paciente'];
    _idterapeuta = snapshot.value['terapeuta'];
    _fechaConsulta = snapshot.value['fecha'];
    _hora = snapshot.value['hora'];
  }
}
