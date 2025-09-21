import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:temu/presentation/widgets/register_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _degradeblanc(context),
          const SizedBox(height: 10),
          _registerTitle(context),
          _subTitleRegister(context),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
          const SizedBox(height: 10,),
          RegisterButton(
            title: 'Continue avec Apple',
            color: Colors.white.withOpacity(0.0),
            border: Border.all(color: Colors.grey.shade400, width: 1),
            imagePath: 'assets/icons/apple.png',
          ),
          const SizedBox(height: 10),
          RegisterButton(
            title: 'Continue avec Google',
            color: Colors.white.withOpacity(0.0),
            border: Border.all(color: Colors.grey.shade400, width: 1),
            imagePath: 'assets/icons/google.png',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Divider(
                  indent: 20,
                  endIndent: 10,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Ou se connecter Avec', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  indent: 20,
                  endIndent: 10,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RegisterButton(
            title: 'Inscription avec Email',
            color: Colors.black,
            imagePath: 'assets/icons/envelope.png',
            textColor: Colors.white,
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: 'Vous avez un compte? ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey
              ),
              children: [
                TextSpan(
                  text: 'Se connecter',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                  ),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    //Action au clic (Naviguer) vers la page login
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}

// Le degrade blanc entre l'image et les composants
Widget _degradeblanc(BuildContext context){
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5, // 40% de l'écran
    child: Stack(
      children: [
        // Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/joice.jpg',
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
                stops: [0.1, 0.4], // contrôle la zone du dégradé
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Le titre de la page RegisterScreen
Widget _registerTitle(BuildContext context){
  return Center(
    child: Text(
      'Welcome back👋',
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Montserrat',
        fontSize: 23,
      ),
    ),
  );
}

// sous titre du RegisrerScreen
Widget _subTitleRegister(BuildContext context){
  return Center(
      child: Text('Les meilleures recettes de cuisine et de\n repas africain',style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
        textAlign: TextAlign.center,
      )
  );
}

// Button continue avec Apple
Widget _continueWithApple(BuildContext context){
  return Container(
    height: 50,
    width: 320,
    padding: EdgeInsets.only(left: 50),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(20)
    ),
    child: Row(
      children: [
        Icon(Icons.apple, size: 30,),
        const SizedBox(width: 20),
        Text('Continue avec Apple', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
        )
      ],
    ),
  );
}
