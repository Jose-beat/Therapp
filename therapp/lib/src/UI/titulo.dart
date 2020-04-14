import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {

  const Titulo({Key key,this.nombre,this.apellidos}) : super(key: key);
   final  String nombre;
   final  String apellidos;
   final double barHeight = 66.0;

  @override
  Widget build(BuildContext context) {
   return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          

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