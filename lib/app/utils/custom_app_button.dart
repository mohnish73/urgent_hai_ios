import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? borderRadius;
  final bool isLoading;
  final bool isDisabled;

  const CustomAppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
    this.textColor,
    this.buttonHeight,
    this.buttonWidth,
    this.borderRadius,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDisabled ? AppColors.medGray : (color ?? AppColors.primary);
    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight ?? 40,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: AppColors.medGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.white,
                ),
              ),
      ),
    );
  }
}
