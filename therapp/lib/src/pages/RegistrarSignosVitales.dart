import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:therapp/src/models/SignosVitales.dart';


class RegistroSignosVitales extends StatefulWidget {
  final SignosVitales signosVitales;
  RegistroSignosVitales({Key key, this.signosVitales}) : super(key: key);

  @override
  _RegistroSignosVitalesState createState() => _RegistroSignosVitalesState();
}
final signosVitalesReference = FirebaseDatabase.instance.reference().child('signos_vitales');


class _RegistroSignosVitalesState extends State<RegistroSignosVitales> {
  List<SignosVitales> items;

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
    _pesoController = new TextEditingController(text: widget.signosVitales.peso);
    _tallaController = new TextEditingController(text: widget.signosVitales.talla);
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Signos Vitales'),
      ),
      body: Container(
              child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _fcController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                  labelText: 'Name'),
                ),
                TextField(
                  controller: _frController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                  labelText: 'Name'),
                ),
                TextField(
                  controller: _pesoController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                  labelText: 'Name'),
                ),
                TextField(
                  controller: _tallaController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                  labelText: 'Name'),
                ),
                FlatButton(
                  onPressed: (){
                    if(widget.signosVitales.id!=null){
                      signosVitalesReference.child(widget.signosVitales.id).set({
                        'frecuencia cardiaca':_fcController.text,
                        'frecuencia respiratoria':_frController.text,
                        'peso': _pesoController.text,
                        'talla':_tallaController.text,
                        'paciente': widget.signosVitales.paciente
                      }).then((_){

                      });
                    }else{
                      signosVitalesReference.push().set({
                        'frecuencia cardiaca':_fcController.text,
                        'frecuencia respiratoria':_frController.text,
                        'peso': _pesoController.text,
                        'talla':_tallaController.text,
                        'paciente': widget.signosVitales.paciente
                      }).then((_){

                      });
                    }
                  }, 
                
                
                child:Text('Siguiente') )
              ],
            ),
          ),
        ),
      ),
    );
  }
}