import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/cubit/splash/splash_cubit.dart';

import '../../cubit/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              SplashCubit()
                ..checkFirstLaunch(), // on lance le check au demarage
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.status == SplashStatus.firstLauch) {
            // Redirection vers le onboarding
            Navigator.pushReplacementNamed(context, '/onboarding');
          } else if (state.status == SplashStatus.notFirstLauch) {
            // Redirection vers Register
            Navigator.pushReplacementNamed(context, '/register');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.deepOrange,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/airbnb.png', height: 110),
                const SizedBox(height: 10),
                Text(
                  'T E M U',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
