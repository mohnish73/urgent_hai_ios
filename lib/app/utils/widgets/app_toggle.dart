import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// btn_toggle.xml  →  Green ON / Grey OFF toggle
// btn_toggle_veg.xml → Red ON / Green OFF toggle
// ─────────────────────────────────────────────────────────────────

/// Standard toggle (btn_toggle.xml)
/// Green when ON, grey when OFF
class AppToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: AppColors.white,
      inactiveTrackColor: AppColors.medGray,
    );
  }
}

/// Veg/Non-veg toggle (btn_toggle_veg.xml)
/// Red when ON (non-veg), Green when OFF (veg)
class VegToggle extends StatelessWidget {
  final bool isNonVeg;
  final ValueChanged<bool> onChanged;

  const VegToggle({
    super.key,
    required this.isNonVeg,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isNonVeg,
      onChanged: onChanged,
      activeColor: AppColors.white,
      activeTrackColor: AppColors.red,
      inactiveThumbColor: AppColors.white,
      inactiveTrackColor: AppColors.primary,
    );
  }
}
