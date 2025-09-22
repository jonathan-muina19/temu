import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnboardingFree extends StatelessWidget {
  const OnboardingFree({super.key});

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
                    'assets/images/jus.png',
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
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(
                textAlign: TextAlign.center,
                'Cuisinez plus malin, mangez mieux',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 23,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Apprenez a faire de jus naturel a un temps record et buvez a votre soif',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
