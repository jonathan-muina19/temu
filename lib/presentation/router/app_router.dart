import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temu/presentation/screens/login_screen.dart';
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
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
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
