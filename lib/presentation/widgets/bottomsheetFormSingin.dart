import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/presentation/widgets/myTextfield.dart';
import 'MyscaffoldMessenger.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class BottomsheetformSignin extends StatefulWidget {
  const BottomsheetformSignin({super.key});

  @override
  State<BottomsheetformSignin> createState() => _BottomsheetformState();
}

class _BottomsheetformState extends State<BottomsheetformSignin> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = controllerEmail.text.trim();
      final password = controllerPassword.text.trim();
      context.read<AuthBloc>().add(SignInRequested(email, password));
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
    if (!value.contains('@')) return 'Email invalide';
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez entrer votre mot de passe';
    if (value.length < 8) return 'Mot de passe trop faible';
    return null;
  }

  @override
  void dispose() {
    controllerPassword.dispose();
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              if (state.message == 'email-not-verified') {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/email-verify',
                    (route) => false
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: MyScaffoldMessenger(
                      title: 'Erreur',
                      message: state.message,
                      color: Colors.red,
                      icon: Icon(Icons.error),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 630),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    backgroundColor: Colors.red,
                    elevation: 20,
                  ),
                );
              }
            } else if (state is AuthSuccess) {
              //Quand l'utilisateur est connecter , on charge les infos firestore

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: MyScaffoldMessenger(
                    title: 'Succes',
                    message: "Connexion reusiie",
                    color: Colors.green,
                    icon: Icon(Icons.check_circle_rounded),
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 630),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: Colors.green,
                  elevation: 20,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/homescreen',
                  (route) => false
              );
            }
          },
          builder: (context, state) {
            return Container(
              width: 430,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Icon(
                      Icons.mail_outline_outlined,
                      color: Colors.orange,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Connectez-vous',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextfield(
                      prefixcon: Icon(Icons.email),
                      hintText: "Adresse email",
                      controller: controllerEmail,
                      validator: emailValidator,
                    ),
                    MyTextfield(
                      prefixcon: Icon(Icons.lock),
                      obscureTextField: true,
                      hintText: "Mot de passe",
                      controller: controllerPassword,
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: GestureDetector(
                        onTap: state is AuthLoading ? null : _login,
                        child: Container(
                          height: 48,
                          width: 326,
                          decoration: BoxDecoration(
                            color:
                            state is AuthLoading
                                ? Colors.orange.shade300
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: state is AuthLoading ?
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ) :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  'Connexion',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
