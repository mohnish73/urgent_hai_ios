/// All non-string app-wide constants: dimensions, durations, keys, limits.
class AppConstants {
  AppConstants._();

  // ─── Hive Storage Keys ────────────────────────────────
  static const String keyUserId = 'userId';
  static const String keyFirstName = 'firstName';
  static const String keyLastName = 'lastName';
  static const String keyMobileNo = 'mobileNo';
  static const String keyEmail = 'email';
  static const String keyGender = 'gender';
  static const String keyDateOfBirth = 'dateOfBirth';
  static const String keyProfilePic = 'profilePic';
  static const String keyGeneralNotification = 'generalNotification';
  static const String keyOrderNotification = 'orderNotification';
  static const String keyEmailNotification = 'emailNotification';
  static const String keyOnboardingDone = 'onboardingDone';

  // ─── Auth Defaults ────────────────────────────────────
  static const String defaultDateOfBirth = '2025-01-01';
  static const String defaultGender = 'Male';

  // ─── Input Limits ─────────────────────────────────────
  static const int phoneLengthMax = 10;
  static const int phoneLengthRequired = 10;
  static const int otpLength = 6;
  static const int nameMaxLength = 50;

  // ─── Timers ───────────────────────────────────────────
  static const int splashDelayMs = 2000;
  static const int otpResendSeconds = 60;

  // ─── Carousel ─────────────────────────────────────────
  static const double carouselHeight = 220;
  static const int carouselAutoPlayMs = 1800;
  static const int carouselAnimationMs = 400;

  // ─── Border Radius ────────────────────────────────────
  static const double radiusCard = 8;
  static const double radiusPill = 50;
  static const double radiusField = 5;
  static const double radiusOnboardTop = 80;

  // ─── Field / Button Heights ───────────────────────────
  static const double fieldHeight = 60;
  static const double buttonHeight = 40;
  static const double bottomNavHeight = 55;

  // ─── Icon / Image Sizes ───────────────────────────────
  static const double backBtnSize = 32;
  static const double backBtnSizeLg = 35;
  static const double logoSizeSplash = 150;
  static const double logoSizeAuth = 120;
  static const double logoSizeSmall = 80;
  static const double locationIconSize = 24;
  static const double navIconSize = 24;
  static const double serviceCardImageW = 100;
  static const double serviceCardImageH = 80;
  static const double serviceCardHeight = 120;
  static const double verifiedIconSize = 50;
  static const double successImageHeight = 320;

  // ─── Onboarding Dots ──────────────────────────────────
  static const double dotActiveWidth = 40;
  static const double dotInactiveWidth = 12;

  // ─── Spacing ──────────────────────────────────────────
  static const double paddingScreen = 15;
  static const double paddingButton = 30;
}
