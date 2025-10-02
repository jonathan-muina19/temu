import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temu/presentation/screens/email_verify_screen.dart';
import 'package:temu/presentation/screens/register_screen.dart';
import 'package:temu/presentation/screens/onboarding/onboarding_two.dart';
import 'package:temu/presentation/screens/onboarding_screen.dart';
import 'package:temu/presentation/screens/register_screen.dart';
import 'package:temu/presentation/screens/splash_screen.dart';

import '../screens/home_screen.dart';


class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/homescreen':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case '/email-verify':
        return MaterialPageRoute(builder: (_) => EmailVerifyScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/onboardingtwo':
        return MaterialPageRoute(builder: (_) => OnboardingTwo());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Page non trouvee : ${routeSettings.name}'),
                ),
              ),
        );
    }
  }
}
