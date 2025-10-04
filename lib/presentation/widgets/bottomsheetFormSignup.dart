import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/bloc/auth/auth_bloc.dart';
import 'package:temu/presentation/widgets/MyscaffoldMessenger.dart';
import 'package:temu/presentation/widgets/myTextfield.dart';

import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class BottomsheetformSingup extends StatefulWidget {
  const BottomsheetformSingup({super.key});

  @override
  State<BottomsheetformSingup> createState() => _BottomsheetformState();
}

class _BottomsheetformState extends State<BottomsheetformSingup> {
  TextEditingController controllerUserName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// validator pour le nom du user
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez entrer votre Nom d'utilisateur";
    }
    return null;
  }

  /// validator pour le nom du user
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrez votre adresse Enail';
    }
    if (!value.contains("@gmail.com")) {
      return "Votre adresse email est invalide";
    }
    return null;
  }

  /// validator pour le mot de passe
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    } else if (value.length <= 8) {
      return 'Mot de passe trop faible';
    }
    return null;
  }

  /// validator pour confirmer le mot de passe
  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    } else if (value.length <= 8) {
      return 'Mot de passe trop faible';
    } else if (value.trim() != controllerPassword.text.trim()) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void _signUpWithEmail() {
    if (_formKey.currentState!.validate()) {
      final email = controllerEmail.text.trim();
      final password = controllerPassword.text.trim();
      final username = controllerUserName.text.trim();
      context.read<AuthBloc>().add(SignUpRequested(email, password, username));
    }
  }

  @override
  void dispose() {
    controllerUserName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is EmailVerificationSent) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                '/email-verify',
                (route) => false
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                content: MyScaffoldMessenger(
                  title: "Confirmation",
                  message: "Email de confirmation envoyer\nVerifier vos mails",
                  color: Colors.blue,
                  icon: Icon(Icons.info_rounded),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 630,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 20,
              ),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                content: MyScaffoldMessenger(
                  title: "Erreur",
                  message: state.message,
                  color: Colors.red,
                  icon: Icon(Icons.error),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: 630,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 20,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              width: 430,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 5),
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.circular(10),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    MyTextfield(
                      prefixcon: Icon(Icons.person),
                      validator: nameValidator,
                      hintText: "Nom d'utilisateur",
                      controller: controllerUserName,
                    ),
                    MyTextfield(
                      validator: emailValidator,
                      prefixcon: Icon(Icons.email_rounded),
                      hintText: "Adresse email",
                      controller: controllerEmail,
                    ),
                    MyTextfield(
                      validator: passwordValidator,
                      prefixcon: Icon(Icons.lock),
                      obscureTextField: true,
                      hintText: "Mot de passe",
                      controller: controllerPassword,
                    ),
                    MyTextfield(
                      validator: confirmPasswordValidator,
                      prefixcon: Icon(Icons.lock),
                      obscureTextField: true,
                      hintText: "Confirmer Mot de passe",
                      controller: controllerConfirmPassword,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: state is AuthLoading ? null : _signUpWithEmail,
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
                            child:
                                state is AuthLoading
                                    ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline_outlined,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Inscription',
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

                    // Pour forcer une espacement
                    Container(margin: EdgeInsets.all(6.0)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// recupere le state du authcubit
