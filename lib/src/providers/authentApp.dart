import 'package:firebase_auth/firebase_auth.dart';

/*Con esta clase definiremos los metodos necesarios para el manejo de acceso de usuarios 
como login, registro, eliminacion,etc.
*/
abstract class BaseAuth {
  /*Metodos de acceso para el inicio de sesion (signIn) y el registro de un usuario (signUp)*/
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
//Metodo para obtener al usuario actual
  Future<FirebaseUser> getCurrentUser();
  //Metodo para la verificacion de email(Omitido en la primera version de la app)
  Future<void> sendEmailVerification();
  //Metodo para cerrar sesion
  Future<void> signOut();
  //Metodo para la verificacion de email(Omitido en la primera version de la app)
  Future<bool> isEmailVerified();
  //Metodo para eliminacion de usuarios 
  Future<void> deleteUser();
}
//Esta clase implementa cada uno de los metodos declarados en la clase anterios

class Autho implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /*Metodos de acceso para el inicio de sesion (signIn) y el registro de un usuario (signUp)*/
  @override
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

//Metodo para obtener al usuario actual

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
//Metodo para cerrar la sesion  

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
//Metodo de verificacion email (omitido en la primera version de la app)
  @override
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

//Metodo para eliminacion de usuarios
  @override
  Future<void> deleteUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.delete();
  }
}
