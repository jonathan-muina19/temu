import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/bloc/auth/auth_bloc.dart';
import 'package:temu/bloc/auth/auth_event.dart';
import 'package:temu/bloc/auth/auth_state.dart';
import 'package:temu/bloc/splash/splash_cubit.dart';
import 'package:temu/bloc/splash/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Vérifie d'abord l'état d'auth
    Future.microtask(() {
      context.read<AuthBloc>().add(CheckAuthStatus());
    });

    // Vérifie si c'est le premier lancement
    Future.microtask(() {
      context.read<SplashCubit>().checkFirstLaunch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Écoute du SplashCubit (SharedPreferences)
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state.status == SplashStatus.firstLaunch) {
              // Redirection vers l'onboarding
              Navigator.pushReplacementNamed(context, '/onboarding');
            } else if (state.status == SplashStatus.notFirstLaunch) {
              // Ici on ne fait rien directement → on laisse AuthBloc décider
              // car l'utilisateur peut déjà être connecté ou pas.
            }
          },
        ),

        // Écoute de l'AuthBloc
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess ) {
              Navigator.pushReplacementNamed(context, '/mainwrapper');
            } else if (state is AuthEmailNotVerified) {
              Navigator.pushReplacementNamed(context, '/email-verify');
            } else if (state is AuthFailure) {
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is AuthInitial) {
              Navigator.pushReplacementNamed(context, '/register');
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/airbnb.png', height: 110),
              const SizedBox(height: 10),
              const Text(
                'T E M U',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
