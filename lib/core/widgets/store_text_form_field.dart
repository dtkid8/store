import 'package:flutter/material.dart';

class StoreTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  const StoreTextFormField({
    super.key,
    required this.controller,
    this.validator,
    required this.label,
    this.obscureText = false,
  });

  @override
  State<StoreTextFormField> createState() => _StoreTextFormFieldState();
}

class _StoreTextFormFieldState extends State<StoreTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        label: Text(widget.label),
        filled: true,
        hintText: "Enter a ${widget.label}",
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
