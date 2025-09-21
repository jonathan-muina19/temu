import 'package:flutter/material.dart';

class ButtonOnboarding extends StatelessWidget {
  final String title;
  final Color color;
  final Color? borderColor;
  final double borderRadius;
  //final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ButtonOnboarding({
    super.key,
    required this.title,
    required this.color,
    required this.borderColor,
    required this.borderRadius,
    //required this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border:
              borderColor != null
                  ? Border.all(color: borderColor!, width: 2)
                  : null,
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            'Get started',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
