import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// toggle_heart.xml  →  Red heart (liked) / Grey heart (unliked)
// ─────────────────────────────────────────────────────────────────

class HeartToggle extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final double size;

  const HeartToggle({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isLiked),
          color: isLiked ? AppColors.red : AppColors.grey,
          size: size,
        ),
      ),
    );
  }
}
