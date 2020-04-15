import 'package:flutter/material.dart';

class EspacioFlexible extends StatelessWidget {
  final String imagen;
  final double appBarHeight = 66.0;
  final String sexo;
  final String edad;
  const EspacioFlexible({Key key, this.imagen, this.sexo, this.edad})
      : super(key: key);

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


                ClipOval(
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
                fadeInCurve: Curves.bounceIn,
                placeholder: AssetImage('assets/images/icon-app.jpeg'),
                image: imagen != null
                    ? NetworkImage(imagen + '?alt=media')
                    : AssetImage('assets/images/photo-null.jpeg'),
              ),
            ),
              
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                    child: new Text("Sexo: $sexo",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Poppins',
                            fontSize: 16.0)),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Container(
                        child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            edad == '1' ?
                            'Edad: $edad año' :
                            'Edad: $edad años',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Poppins',
                                fontSize: 16.0),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
      decoration: new BoxDecoration(
        color: Colors.teal[300],
      ),
    );
  }
}
