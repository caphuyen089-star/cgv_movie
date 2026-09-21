import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;

  final String hint;

  final IconData icon;

  final bool obscureText;

  const CustomTextField({

    super.key,

    required this.controller,

    required this.hint,

    required this.icon,

    this.obscureText = false,

  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      obscureText: obscureText,

      decoration: InputDecoration(

        prefixIcon: Icon(icon),

        hintText: hint,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12),

        ),

      ),

    );

  }

}