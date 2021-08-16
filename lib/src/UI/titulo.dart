import 'package:flutter/material.dart';

/*Clase que solo determinara el formato del titulo al entrar al expediente 
del paciente indicado 
*/
class Titulo extends StatelessWidget {

  const Titulo({Key key,this.nombre,this.apellidos}) : super(key: key);
  //Obtenemos los datos de la clase que ejecuta la base de datos 
   final  String nombre;
   final  String apellidos;
   final double barHeight = 66.0;

  @override
  Widget build(BuildContext context) {
   return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Definimos el formato del titulo principal

          Container(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$nombre $apellidos',
              style: TextStyle(
                color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15.0
              ),
            ),

          ),),


        ],
      ),
    );
  }
}