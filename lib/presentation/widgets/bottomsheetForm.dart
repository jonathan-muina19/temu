import 'package:flutter/material.dart';
import 'package:temu/presentation/widgets/myTextfield.dart';

class Bottomsheetform extends StatefulWidget {
  const Bottomsheetform({super.key});

  @override
  State<Bottomsheetform> createState() => _BottomsheetformState();
}

class _BottomsheetformState extends State<Bottomsheetform> {

  TextEditingController controllerUsreName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: 430,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5,),
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.mail_outline_outlined,
                            color: Colors.orange,
                            size: 50,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.start,
                        'Inscrivez-vous',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontSize: 23,
                        )
                    )
                  ],
                ),
              ),
              MyTextfield(
                  hintText: "Adresse email",
                  controller: controllerEmail
              ),
              MyTextfield(
                obscureTextField: true,
                  hintText: "Mot de passe",
                  controller: controllerPassword
              ),
              MyTextfield(
                obscureTextField: true,
                  hintText: "Confirmer Mot de passe",
                  controller: controllerUsreName
              ),
              Center(child: _inscriptionWithEmail(context)),
              // Pour forcer une espacement
              Container(margin: EdgeInsets.all(6.0)),
            ],
          ),
        ),
      ),
    );
  }
}


// Button inscription avec email
Widget _inscriptionWithEmail(BuildContext context) {
  return Container(
    height:48,
    width: 326,
    //padding: EdgeInsets.only(left: 50),
    decoration: BoxDecoration(
      color: Colors.orange,
      border: Border.all(color: Colors.grey.shade400, width: 1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline_outlined, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            'Inscription',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ],
      ),
    ),
  );
}