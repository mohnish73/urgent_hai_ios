import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_decorations.dart';

// ─────────────────────────────────────────────────────────────────
// password_toggle.xml  →  show / hide password eye icon
// ─────────────────────────────────────────────────────────────────

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.editTextBg,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        validator: widget.validator,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.textHint, fontFamily: 'Urbanist'),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              // password_toggle.xml: showpassword1 / hidepassword1
              _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.gray,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
