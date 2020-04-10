import 'package:flutter/material.dart';

class EspacioFlexible extends StatelessWidget {
  final String imagen;
  final double appBarHeight = 66.0;
  final String sexo;
  final String edad;
  const EspacioFlexible({Key key,this.imagen, this.sexo, this.edad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
  return Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,

      child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                     
                      backgroundImage: imagen != null ? 
                      NetworkImage(imagen + '?alt=media'):
                      AssetImage('assets/photo-null.jpeg'),
                     
                     
                    
                    ),
                   
                  ],),),

              


              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,left:8.0),
                      child: new Text(
                          "Sexo: $sexo",
                          style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                              fontSize: 16.0
                          )
                      ),
                    ),),

                    Container(child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,right:8.0),
                      child: Container(
                          child: Row(children: <Widget>[
                           
                            SizedBox(width: 10,),
                            Container(child: Text(
                              'Edad: $edad años', style: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Poppins',
                                fontSize: 16.0
                            ),),),
                          ],)

                      ),
                    ),),


                  ],),
              ),
            ],)
      ),
      decoration: new BoxDecoration(
        color: Color(0xff013db7),
      ),
    );
  
  }
}