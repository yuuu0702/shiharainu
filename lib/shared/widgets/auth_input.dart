import 'package:flutter/material.dart';

// Governed by Skill: shiharainu-login-design
class AuthInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? icon;

  const AuthInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.icon,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused
                ? Colors.white
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.label,
            labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            floatingLabelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 20,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    );
  }
}
