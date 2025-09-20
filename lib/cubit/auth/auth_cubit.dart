import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/cubit/auth/auth_state.dart';
import 'package:temu/data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthState());

  // Etat Connexion
  Future<void> signIn(String email, String password) async {
    emit(AuthState(isLoading: true));
    try {
      final user = await authRepository.signIn(email, password);
      emit(AuthState(user: user));
    } catch (e) {
      emit(AuthState(error: e.toString()));
    }
  }

  //Etat Register
  Future<void> signUp(String email, String password) async {
    emit(AuthState(isLoading: true));
    try {
      final user = await authRepository.signUp(email, password);
      emit(AuthState(user: user));
    } catch (e) {
      emit(AuthState(error: e.toString()));
    }
  }

  // Etat deconnexion
  Future<void> signOut() async {
    await authRepository.signOut();
    emit(AuthState());
  }

  // Observer l'etat de l'utlisisateur actuel
  void checkAuthStatus() {
    authRepository.user.listen((user) {
      if (user != null) {
        // Utilisateur connecté
        emit(AuthState(user: user));
      } else {
        // Utilisateur non connecté
        emit(AuthState());
      }
    });
  }
}
