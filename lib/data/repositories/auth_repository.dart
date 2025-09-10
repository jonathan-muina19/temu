import 'package:firebase_auth/firebase_auth.dart';
import '../dataproviders/firebase_auth_provider.dart';

class AuthRepository {
  // On instancie AuthProvider
  final MyAuthProvider _authProvider;

  AuthRepository(this._authProvider);

  // Ecouter les changements de l'utilisateur
  Stream<User?> get user => _authProvider.userChanges;

  // Cree un compte
  Future<User?> signUp(String email, String password) async{
    try{
      User? user = await _authProvider.signUp(email, password);
      return user;
    }catch (e){
      throw Exception("Erreur repository signUp : $e");
    }
  }

  // Se connecter
  Future<User?> signIn(String email, String password) async{
    try{
      User? user = await _authProvider.signIn(email, password);
      return user;
    }catch (e){
      throw Exception("Erreur repository signIn : $e");
    }
  }

  // Se deconnecter
  Future<void> signOut() async{
    await _authProvider.signOut();
  }

  // Obtenur l'utilosateur actuel
  User? get currentUser => _authProvider.currentUser;


}
