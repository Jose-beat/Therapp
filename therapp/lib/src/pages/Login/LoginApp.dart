import 'dart:async';

import 'package:flutter/material.dart';
import 'package:therapp/src/models/Terapeuta.dart';
import 'package:therapp/src/pages/Register/RegistroPerfil.dart';
import 'package:therapp/src/providers/authentApp.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  
  Color colorRegistro = Colors.orange;
  String iniciar = 'Iniciar Sesion';
  String indicacion = 'Inicia sesion';
  TextEditingController correo;
  bool _oscurecido = true;
  Widget ojos = Icon(Icons.visibility);
  final _formKey = new GlobalKey<FormState>();
  String _key;
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;
  double logo = 30.0;
  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _createNewTerapeuta(
      BuildContext context, String email, String userId) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistroPerfil(
                  terapeuta: Terapeuta(userId, '', '', '','', email, '', '', '',''),
                  id: userId,
                  email: email,
                  imagenPerfil: true,
                )));
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          _createNewTerapeuta(context, _email, userId);
          print('Signed up user: $userId');
          _key = userId;
          print(_key);
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    colorRegistro = Colors.orange;
    iniciar = 'Iniciar Sesion';
    indicacion = 'Iniciar Sesion';
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
      colorRegistro = _isLoginForm ? Colors.orange:Colors.teal[300];
      indicacion = _isLoginForm ?  'Inicia Sesion' :'Registrate'  ;

    });
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: AppBar(
        title: Text(indicacion,
        style: TextStyle(
          fontSize: 15.0
        ),
        ),
       
        backgroundColor: colorRegistro,
        elevation: 0.0,
      ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    
    return new Container(
  
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              Container(
                width: 30.0,
                height: 30.0,
              ),
              showSecondaryButton(),
              showErrorMessage(context),
              
              
            ],
          ),
        ));
  }

  Widget showErrorMessage(BuildContext context){
    if (_errorMessage.length > 0 && _errorMessage != null) {
      
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w500),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 88.0,
          child: Image.asset('assets/images/icon-app.jpeg'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        
        controller: correo,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Correo Electronico',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green
              ),
              borderRadius: BorderRadius.circular(0.0)),
            prefixIcon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Correo invalido' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
      
        maxLines: 1,
        obscureText: _oscurecido,
        autofocus: false,
        decoration: new InputDecoration(
          
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: GestureDetector(
            child: _oscurecido == true ? ojos: Icon(Icons.visibility_off),
            onTap: (){
              setState(() {
                _oscurecido = !_oscurecido;
              
              });
            },
          ),
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
            hintText: 'Contraseña',
            prefixIcon:new Icon(
              Icons.lock,
              color: Colors.grey,
            ) ,
            
            ),
        validator: (value) => value.isEmpty ? 'Contraseña invalida' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? '¿Primer vez? Crea una Cuenta' : '¿Tienes cuenta?\nEntonces Inicia Sesion',
            style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: _isLoginForm ? Colors.orange[800]:Colors.teal[500],
              child: new Text(_isLoginForm ? 'Iniciar Sesion' : 'Crear Cuenta',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: validateAndSubmit),
        ));
  }







  
  
}
