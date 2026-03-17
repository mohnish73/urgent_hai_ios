/// All UI-visible strings in one place.
/// Never hardcode strings in screens — always reference from here.
class AppStrings {
  AppStrings._();

  // ─── App ──────────────────────────────────────────────
  static const String appName = 'UrgentHai';

  // ─── Onboarding ───────────────────────────────────────
  static const String ob1Title = 'Welcome to Urgent Hai';
  static const String ob1Desc =
      'Your one-stop solution for rides and doorstep deliveries.';
  static const String ob2Title = 'Book a Ride Instantly';
  static const String ob2Desc =
      'Get a cab with a tap at your fingertips at the earliest.';
  static const String ob3Title = 'Shop from Nearby Stores';
  static const String ob3Desc =
      'Groceries & essentials, delivered from local shops!';

  // ─── Auth – Login ─────────────────────────────────────
  static const String loginTitle = 'Welcome back! Glad\n to see you, Again!';
  static const String loginPhoneHint = 'Enter your Mobile No.';
  static const String loginContinue = 'Continue';
  static const String loginNoAccount = "Don't have an account?";
  static const String loginRegisterNow = ' Register Now';
  static const String errorPhoneRequired = 'Mobile number is required';
  static const String errorPhoneInvalid = 'Enter valid mobile number';

  // ─── Auth – OTP ───────────────────────────────────────
  static const String otpTitle = 'OTP';
  static const String otpLogin = 'Login';
  static const String otpResendCode = 'Resend Code';
  static const String otpResendAvailable = 'You can resend the code';
  static const String errorOtpInvalid = 'Enter valid otp';

  // ─── Auth – Signup ────────────────────────────────────
  static const String signupTitle = 'Hello! Register to get\nstarted';
  static const String signupFirstNameHint = 'Enter your first name';
  static const String signupLastNameHint = 'Enter your last name';
  static const String signupEmailHint = 'Enter your email';
  static const String signupPhoneHint = 'Enter your Mobile No.';
  static const String signupContinue = 'Continue';
  static const String signupHaveAccount = 'Already have an account?';
  static const String signupLoginNow = ' Login Now';
  static const String errorFirstNameRequired = 'First name is required';
  static const String errorLastNameRequired = 'Last name is required';
  static const String errorEmailRequired = 'Email is required';
  static const String errorMobileRequired = 'Mobile number is required';
  static const String errorMobileInvalid = 'Enter a valid mobile number';

  // ─── Auth – Signup Success ────────────────────────────
  static const String signupSuccessTitle = 'All Done';
  static const String signupSuccessDesc =
      "Thanks for giving us your precious time. Now you are ready to explore the world of Urgent Hai's";
  static const String signupSuccessBtn = "Let's Go";

  // ─── Common Buttons ───────────────────────────────────
  static const String btnSkip = 'Skip';
  static const String btnContinue = 'Continue';

  // ─── Home ─────────────────────────────────────────────
  static const String homeWelcomeNote =
      'Your go to partner for all you need \n quickly be it a ride or a grocery!';
  static const String homeFooterTitle = 'UrgentHai';
  static const String homeFooterTagline = 'Eat. Ride. Deliver.One App Away.';

  // Service cards
  static const String serviceRide = 'Ride';
  static const String serviceRideDesc = 'Get a ride';
  static const String serviceParcel = 'Parcel';
  static const String serviceParcelDesc = 'Send a Parcel';
  static const String serviceStore = 'Store';
  static const String serviceStoreDesc = 'Grocery, cafe\nand more.';

  // Slider captions
  static const String slide1Caption = 'Urgent Hai: Fast Rides';
  static const String slide2Caption = 'Groceries, Meals, Trusted Partners';
  static const String slide3Caption = 'UrgentHai Selects, You Save';
  static const String slide4Caption = 'Seamless Logistics, Faster Delivery';

  // Location
  static const String defaultCountry = 'India';
  static const String locationNotFound = 'Address not found';
  static const String locationTapToUpdate = 'Tap to update';
}
