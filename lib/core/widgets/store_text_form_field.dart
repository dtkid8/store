import 'dart:async';
import 'package:flutter/material.dart';

class StoreTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Function(String)? onChanged;
  final Duration debounceDuration;
  final String? hintText;
  final Widget? suffixIcon;
  const StoreTextFormField({
    super.key,
    required this.controller,
    this.validator,
    required this.label,
    this.obscureText = false,
    this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.hintText,
    this.suffixIcon,
  });

  @override
  State<StoreTextFormField> createState() => _StoreTextFormFieldState();
}

class _StoreTextFormFieldState extends State<StoreTextFormField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel(); // Ensure to cancel the timer on dispose
    super.dispose();
  }

  void _onChangedDebounced(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(widget.debounceDuration, () {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: _onChangedDebounced, // Use the debounced onChanged
      obscureText: widget.obscureText,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        labelText: widget.label,
        filled: true,
        hintText: widget.hintText ?? "Enter a ${widget.label}",
        floatingLabelStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
