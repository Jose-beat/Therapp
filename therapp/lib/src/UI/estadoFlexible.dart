import 'package:flutter/material.dart';

class EspacioFlexible extends StatelessWidget {
  final String imagen;
  final double appBarHeight = 66.0;
  const EspacioFlexible({Key key,this.imagen}) : super(key: key);

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
                    
                      child:  imagen == null ?
                      Text('No hay imagen')
                      :Image.network(imagen + '?alt=media', fit: BoxFit.fill,)
                    
                    ),
                   
                  ],),),

              


              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,left:8.0),
                      child: new Text(
                          "Currency",
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
                            Container(child: Icon(
                              Icons.ac_unit, color: Colors.white,
                            ),),
                            SizedBox(width: 10,),
                            Container(child: Text(
                              'Janaury 2019', style: const TextStyle(
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