import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Flutter equivalents of all Android XML drawable shapes.
/// Use these instead of writing BoxDecoration inline everywhere.
class AppDecorations {
  // ─────────────────────────────────────────────────────────────
  // CIRCLES
  // ─────────────────────────────────────────────────────────────

  /// bg_circle.xml — white solid oval
  static const BoxDecoration bgCircle = BoxDecoration(
    color: AppColors.white,
    shape: BoxShape.circle,
  );

  /// green_circle.xml — primary green circle
  static const BoxDecoration greenCircle = BoxDecoration(
    color: AppColors.primary,
    shape: BoxShape.circle,
  );

  /// green_light_circle.xml — light green circle
  static const BoxDecoration greenLightCircle = BoxDecoration(
    color: AppColors.lightGreen,
    shape: BoxShape.circle,
  );

  // ─────────────────────────────────────────────────────────────
  // RECTANGLES — Solid fills
  // ─────────────────────────────────────────────────────────────

  /// rectabngle_white.xml — white, radius 8dp
  static const BoxDecoration rectangleWhite = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  /// rectangle_rounded_white.xml — white, radius 4dp
  static const BoxDecoration rectangleRoundedWhite = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  /// rounded_lightgreen.xml — light green, radius 8dp
  static const BoxDecoration roundedLightGreen = BoxDecoration(
    color: AppColors.lightGreen,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  // ─────────────────────────────────────────────────────────────
  // RECTANGLES — With borders
  // ─────────────────────────────────────────────────────────────

  /// edittext_bg.xml — lightgrey fill, gray border 0.3dp, radius 5dp
  static const BoxDecoration editTextBg = BoxDecoration(
    color: AppColors.lightGrey,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.gray, width: 0.3),
    ),
  );

  /// search_bg.xml — white fill, gray border 1dp, radius 5dp
  static const BoxDecoration searchBg = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.gray, width: 1),
    ),
  );

  /// rectangle_rounded_grey_box.xml — lightgrey fill, greyBorder stroke 2dp, radius 4dp
  static const BoxDecoration rectangleRoundedGreyBox = BoxDecoration(
    color: AppColors.lightGrey,
    borderRadius: BorderRadius.all(Radius.circular(4)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.greyBorder, width: 2),
    ),
  );

  /// rectangle_white_black_border.xml — white fill, black border 1dp, radius 8dp
  static const BoxDecoration rectangleWhiteBlackBorder = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.black, width: 1),
    ),
  );

  /// rectangle_lightyellow_black_border.xml — lightyellow fill, black border 0.4dp, radius 4dp
  static const BoxDecoration rectangleLightYellowBlackBorder = BoxDecoration(
    color: AppColors.lightyellow,
    borderRadius: BorderRadius.all(Radius.circular(4)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.black, width: 0.4),
    ),
  );

  /// selected_rectangle_primar.xml — light green fill, primary border 1dp, radius 8dp
  /// Used for selected/active state of ride/parcel type cards
  static const BoxDecoration selectedRectanglePrimary = BoxDecoration(
    color: AppColors.lightGreen,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.primary, width: 1),
    ),
  );

  /// photo_border.xml — transparent fill, white border 1dp, radius 4dp
  static const BoxDecoration photoBorder = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(4)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.white, width: 1),
    ),
  );

  // ─────────────────────────────────────────────────────────────
  // SPECIAL SHAPES
  // ─────────────────────────────────────────────────────────────

  /// bottom_sheet_bg.xml — white, top corners 24dp only
  static const BoxDecoration bottomSheetBg = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
  );

  /// green_bottom_rectangle.xml — primary green, bottom corners 80dp only
  /// Used as header/banner background
  static const BoxDecoration greenBottomRectangle = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(80),
      bottomRight: Radius.circular(80),
    ),
  );

  /// drag_handle_bg.xml — medgray, radius 2dp (the small pill handle on bottom sheets)
  static const BoxDecoration dragHandleBg = BoxDecoration(
    color: AppColors.medGray,
    borderRadius: BorderRadius.all(Radius.circular(2)),
  );

  /// top_rectangle_white_color.xml — white with subtle grey outer shadow border
  /// Used as card/container background with shadow effect
  static BoxDecoration topRectangleWhite = BoxDecoration(
    color: AppColors.white,
    border: Border.all(color: AppColors.grey, width: 0.5),
    boxShadow: const [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────
  // TILED BACKGROUND
  // ─────────────────────────────────────────────────────────────

  /// doodle_tiled.xml — repeating tiled doodle background
  /// Usage: place inside a Container, make sure 'assets/images/doodle_bg.png' exists
  static BoxDecoration doodleTiled = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/doodle_bg.png'),
      repeat: ImageRepeat.repeat,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────
// DRAG HANDLE WIDGET
// ─────────────────────────────────────────────────────────────────

/// Reusable drag handle shown at top of bottom sheets (drag_handle_bg.xml)
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: AppDecorations.dragHandleBg,
      ),
    );
  }
}
