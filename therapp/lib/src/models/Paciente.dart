import 'package:firebase_database/firebase_database.dart';
/*clase para manejo de modelos que usaremos para realizar CRUD en cada entidad*/
class Paciente {
    //Atributos de nuestro modelo
  String _id;
  String _nombre;
  String _apellidos;
  String _nacimiento;
  int _edad;
  String _ocupacion;
  String _sexo;
  String _terapeuta;
  String _imagenPaciente;
//contructor para el acceso en demas clases 
  Paciente(this._id, this._nombre, this._apellidos,this._nacimiento ,this._edad, this._ocupacion,
      this._sexo, this._terapeuta,this._imagenPaciente);
//Mapeo de cada elemento en la columnba indicada 
  Paciente.map(dynamic obj) {
    this._nombre = obj['nombre'];
    this._apellidos = obj['apellidos'];
    this._nacimiento = obj['nacimiento'];
    this._edad = obj['edad'];
    this._ocupacion = obj['ocupacion'];
    this._sexo = obj['sexo'];
    this._terapeuta = obj['terapeuta'];
    this._imagenPaciente = obj['imagen'];
  }
//metodo get para acceso en otras clases 
  String get id => _id;
  String get nombre => _nombre;
  String get apellidos => _apellidos;
  String get nacimiento => _nacimiento;
  int get edad => _edad;
  String get ocupacion => _ocupacion;
  String get sexo => _sexo;
  String get terapeuta => _terapeuta;
  String get imagenPaciente => _imagenPaciente;
//ESCRITURA DE DATOS EN EL MODELO Y CREACION DE LA TABLA 
  Paciente.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _nombre = snapshot.value['nombre'];
    _apellidos = snapshot.value['apellidos'];
    _nacimiento = snapshot.value['nacimiento'];
    _edad = snapshot.value['edad'];
    _ocupacion = snapshot.value['ocupacion'];
    _sexo = snapshot.value['sexo'];
    _terapeuta = snapshot.value['terapeuta'];
    _imagenPaciente = snapshot.value['imagen'];
  }
}
