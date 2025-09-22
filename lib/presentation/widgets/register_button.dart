import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color color;
  final Color? textColor;
  final Border? border;
  final VoidCallback? onTap;

  const RegisterButton({
    super.key,
    required this.title,
    required this.color,
    this.border,
    required this.imagePath,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 320,
        padding: EdgeInsets.only(left: 50),
        decoration: BoxDecoration(
          color: color,
          border: border, //Border.all(color: Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset('${imagePath}', width: 22),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
