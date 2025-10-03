import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/bloc/auth/auth_event.dart';
import 'package:temu/bloc/auth/auth_state.dart';
import 'package:temu/data/repositories/auth_repository.dart';

import '../../data/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // Connexion
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Connexion via repository
        await authRepository.signIn(event.email, event.password);

        final user = FirebaseAuth.instance.currentUser;

        // Vérifier si l'utilisateur est connecté et email vérifié
        if (user != null && !user.emailVerified) {
          emit(AuthFailure('email-not-verified'));
          return;
        }

        if (user != null) {
          // 🔥 Récupérer les infos Firestore
          final snapshot = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

          if (snapshot.exists) {
            final data = snapshot.data()!;
            final userModel = UserModel.fromMap(data, user.uid);

            // ✅ On envoie AuthSuccess avec toutes les infos
            emit(AuthSuccess(userModel));
          } else {
            emit(AuthFailure("Aucune donnée utilisateur trouvée"));
          }
        } else {
          emit(AuthFailure("Utilisateur introuvable"));
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Utilisateur non trouvé';
            break;
          case 'wrong-password':
            message = 'Mot de passe incorrect';
            break;
          case 'invalid-email':
            message = 'Email invalide';
            break;
          case 'invalid-credential':
            message = 'Email ou mot de passe incorrect!';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });


    // Inscription
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Inscription avec le repository
        await authRepository.signUp(
          event.email,
          event.password,
          event.username,
        );
        // Envoyer l'email de vérification
        await authRepository.sendEmailVerification();
        emit(EmailVerificationSent());
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Cet email est déjà utilisé.';
            break;
          case 'invalid-email':
            message = 'Email invalide.';
            break;
          case 'weak-password':
            message = 'Mot de passe trop faible.';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure("Une erreur s'est produite\nRessayez plus tard"));
      }
    });

    // Déconnexion
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 5));
      await authRepository.signOut();
      emit(AuthInitial());
    });

    // Vérifier statut
    on<CheckAuthStatus>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));

      try {
        final isLoggedIn = await authRepository.isSignedIn.first;

        if (isLoggedIn) {
          final user = FirebaseAuth.instance.currentUser;

          if (user != null && !user.emailVerified) {
            emit(AuthEmailNotVerified());
            return;
          }

          if (user != null) {
            // Récupérer le document Firestore
            final snapshot = await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();

            if (snapshot.exists) {
              final data = snapshot.data()!;
              final userModel = UserModel.fromMap(data, user.uid);

              emit(AuthSuccess(userModel)); // ✅ tu passes UserModel
            } else {
              emit(AuthFailure("Utilisateur introuvable dans Firestore"));
            }
          }
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    //
    on<CheckEmailVerified>((event, emit) async {
      // Emettre l'état de chargement
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        // Vérifier si l'email est vérifié
        final user = FirebaseAuth.instance.currentUser;
        await user?.reload(); // Recharger l'utilisateur
        // Si oui, emiter l'état d'email vérifié
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null && refreshedUser.emailVerified) {
          emit(AuthEmailVerified());
        } else {
          emit(AuthEmailNotVerified());
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Utilisateur non trouvé';
            break;
          case 'invalid-email':
            message = 'Email invalide';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
