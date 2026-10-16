import 'package:flutter/material.dart';
import '../../theme/app_design_system.dart';

/// Premium styled text field for authentication forms.
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? labelText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: context.fc.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: context.fc.textMuted, fontSize: 15),
        labelText: labelText,
        labelStyle: TextStyle(color: context.fc.textMuted, fontSize: 14),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: context.fc.textMuted, size: 22)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: context.fc.inputBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
          borderSide: BorderSide(color: context.fc.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
          borderSide: BorderSide(color: context.fc.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
          borderSide:
              const BorderSide(color: FloosyDesign.primaryPurple, width: 1.5),
        ),
      ),
    );
  }
}
