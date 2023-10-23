import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  double? height;
  double? width;
  double margin;
  double paddding;

  MyButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.height,
    this.width = double.infinity,
    this.margin = 10,
    this.paddding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.all(paddding),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Color(0xff6292ed),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
