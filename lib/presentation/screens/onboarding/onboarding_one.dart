import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, // 40% de l'écran
            child: Stack(
              children: [
                // Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/chef3.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Dégradé blanc en bas de l’image
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white.withOpacity(0.9), // haut (blanc visible)
                          Colors.white.withOpacity(0.0), // vers transparent
                        ],
                        stops: [0.1, 0.3], // contrôle la zone du dégradé
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Bienvenue sur TEMU👋',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 23,
              ),
            ),
          ),
          Text(
            'Des repas faciles, savoureux et sains\n à portée de main',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
