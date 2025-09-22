import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final controller;
  final bool obscureTextField;

  MyTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureTextField = false,
  });

  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: TextFormField(
        obscureText: obscureTextField,
        cursorColor: Colors.black,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(13),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(13),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(13),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(13),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade700),
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
