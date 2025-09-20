import 'package:firebase_auth/firebase_auth.dart';
// C;est ici qu'on va faire notre code brute
// pas de logique d'auth

class MyAuthProvider {
  // On instancie FIREBASE
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // On Ecoute L'etat de l'utilisateur (Connecter ou Non connecter)
  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();

  // Register (Creer un compte)
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Erreur d'inscription : ${e.message}");
    }
  }

  // Signin (Se connecter )
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Erreur de connexion : ${e.message}");
    }
  }

  // Singout (Se deconnecter)
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Obtenir l'utilisateur actuel
  User? get currentUser => _firebaseAuth.currentUser;
}
