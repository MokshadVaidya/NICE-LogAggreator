import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  const CustomTextField(
    this.hintText,
    this.icon, {
    super.key,
    required this.controller,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      style:
          (const TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        fillColor: Colors.black.withAlpha(75),
        filled: true,
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      controller: controller,
    );
  }
}