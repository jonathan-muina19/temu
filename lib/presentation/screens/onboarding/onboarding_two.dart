import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingTwo extends StatefulWidget {
  const OnboardingTwo({super.key});

  @override
  State<OnboardingTwo> createState() => _OnboardingTwoState();
}

class _OnboardingTwoState extends State<OnboardingTwo> {
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
                    'assets/images/juice.jpg',
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
              textAlign: TextAlign.center,
              "L'inspiration culinaire de chaque jour",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 23,
              ),
            ),
          ),
          Text(
            "Des recettes traditionnelles aux saveurs modernes. ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
