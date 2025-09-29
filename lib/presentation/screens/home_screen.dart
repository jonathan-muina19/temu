import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Firebase Authentification
    final user = FirebaseAuth.instance.currentUser;

    /// Email de l'utilisateur
    final email = user?.email ?? 'Compte ou Email non disponible';

    /// Extraction du texte avant le @
    final username = email.contains('@') ? email.split('@')[0] : email;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure || state is AuthInitial) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/register', (route) => false
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Déconnexion en cours...'),
                  CircularProgressIndicator(
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, color: Colors.redAccent, size: 25),
                    const SizedBox(height: 20),
                    Text('Bienvenue : $username'),
                    Text(
                      'Connecté en tant que ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$email',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed:(){
                          context.read<AuthBloc>().add(SignOutRequested());
                        },
                        child: Text('Deconnexion'))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
