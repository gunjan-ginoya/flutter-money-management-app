// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget? endIcon;
  final Function()? onChanged;
  TextInputType? keyboardType;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.endIcon,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: HexColor("#4f4f4f"),
      autofocus: false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        hintStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: HexColor("#8d8d8d"),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff3a69a9),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: Color(0xff3a69a9),
        suffixIcon: endIcon,
        suffixIconColor: Color(0xff3a69a9),
        filled: true,
      ),
    );
  }
}
