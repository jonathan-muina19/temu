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
                    'assets/images/madeblo.png',
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
                        stops: [0.0, 0.6], // contrôle la zone du dégradé
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
              textAlign: TextAlign.center,
              'Cuisinez plus malin, mangez mieux',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 23,
              ),
            ),
          ),
          Text(
            'Cuisinez les classiques congolais et bien plus encore',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
