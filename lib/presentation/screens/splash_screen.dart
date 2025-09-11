import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF129575),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/image 11.png'),
            const SizedBox(height: 10),
            Text('T E M U', style: TextStyle(
              fontFamily: 'Poppins',
              //fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}
