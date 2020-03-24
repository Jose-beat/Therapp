import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/SignosVitales.dart';

class RegistroSignosVitales extends StatefulWidget {
  final SignosVitales signosVitales;
  RegistroSignosVitales({Key key, this.signosVitales}) : super(key: key);

  @override
  _RegistroSignosVitalesState createState() => _RegistroSignosVitalesState();
}

final signosVitalesReference =
    FirebaseDatabase.instance.reference().child('signos_vitales');

class _RegistroSignosVitalesState extends State<RegistroSignosVitales> {
  List<SignosVitales> items;
  String frecuenciaCardiActual = '70 - 190';
  String frecuenciaRespiratoryActual = '30 - 80';
  double peso = 40.0;
  String talla = 'XS';

  TextEditingController _fcController;
  TextEditingController _frController;
  TextEditingController _pesoController;
  TextEditingController _tallaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fcController = new TextEditingController(text: widget.signosVitales.fc);
    _frController = new TextEditingController(text: widget.signosVitales.fr);
    _pesoController =
        new TextEditingController(text: widget.signosVitales.peso.toString());
    _tallaController =
        new TextEditingController(text: widget.signosVitales.talla.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Signos Vitales'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: Center(
                child: Column(
                  children: <Widget>[
                    cardiacOption(),
                    respiratoryOption(),
                    pesoOption(),
                    tallaOption(),
                    FlatButton(
                        onPressed: () {
                          if (widget.signosVitales.id != null) {
                            signosVitalesReference
                                .child(widget.signosVitales.id)
                                .set({
                              'frecuencia cardiaca': frecuenciaCardiActual,
                              'frecuencia respiratoria':
                                  frecuenciaRespiratoryActual,
                              'peso': peso,
                              'talla': talla,
                              'paciente': widget.signosVitales.paciente
                            }).then((_) {});
                          } else {
                            signosVitalesReference.push().set({
                              'frecuencia cardiaca': frecuenciaCardiActual,
                              'frecuencia respiratoria':
                                  frecuenciaRespiratoryActual,
                              'peso': peso,
                              'talla': talla,
                              'paciente': widget.signosVitales.paciente
                            }).then((_) {});
                          }
                        },
                        child: Text('Siguiente'))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardiacOption() {
    return DropdownButton<String>(
      value: frecuenciaCardiActual,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          frecuenciaCardiActual = newValue;
        });
      },
      items: <String>[
        '70 - 190',
        '80 - 160',
        '80 - 130',
        '80 - 120',
        '75 - 115',
        '70 - 110',
        '60 - 100'
      ].map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget respiratoryOption() {
    return DropdownButton<String>(
      value: frecuenciaRespiratoryActual,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          frecuenciaRespiratoryActual = newValue;
        });
      },
      items: <String>['30 - 80', '20 - 40', '20 - 30', '20 - 25', '15 - 20']
          .map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget pesoOption() {
    return DropdownButton<double>(
      value: peso,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (double newValue) {
        setState(() {
          peso = newValue;
        });
      },
      items: pesos().map<DropdownMenuItem<double>>((dynamic value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Text('$value'),
        );
      }).toList(),
    );
  }

  List pesos() {
    List<int> peso = [];

    for (var i = 30; i < 100.0; i += 10) {
      peso.add(i);
      print(i);
    }
    return peso;
  }

  Widget tallaOption() {
    return DropdownButton<String>(
      value: talla,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          talla = newValue;
        });
      },
      items: <String>['XS', 'S', 'M', 'L', 'XL', 'XXL']
          .map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
