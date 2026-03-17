import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';
import '../../model/auth/login_response_model.dart';

class HiveService {
  static Box _getBox() {
    if (!Hive.isBoxOpen(AppConfig.authBox)) {
      throw Exception('Hive authBox is not open. Call Hive.openBox() in main.');
    }
    return Hive.box(AppConfig.authBox);
  }

  // ─── Auth State ──────────────────────────────────────
  static bool isLoggedIn() => getUserId() != null;

  // ─── User Data ───────────────────────────────────────
  static Future<void> saveUserData(UserData user) async {
    final box = _getBox();
    await box.put('userId', user.pkUserId.toString());
    await box.put('firstName', user.firstName);
    await box.put('lastName', user.lastName);
    await box.put('mobileNo', user.mobileNo);
    await box.put('email', user.emailId ?? '');
    await box.put('gender', user.gender);
    await box.put('dateOfBirth', user.dateOfBirth);
    await box.put('profilePic', user.profilePic ?? '');
    await box.put('generalNotification', user.generalNotification);
    await box.put('orderNotification', user.orderNotification);
    await box.put('emailNotification', user.emailNotification);
  }

  static String? getUserId() => _getBox().get('userId');
  static String getFullName() {
    final first = _getBox().get('firstName', defaultValue: '') as String;
    final last = _getBox().get('lastName', defaultValue: '') as String;
    return '$first $last'.trim();
  }

  static String? getFirstName() => _getBox().get('firstName');
  static String? getLastName() => _getBox().get('lastName');
  static String? getMobileNo() => _getBox().get('mobileNo');
  static String? getEmail() => _getBox().get('email');
  static String? getGender() => _getBox().get('gender');
  static String? getDateOfBirth() => _getBox().get('dateOfBirth');
  static String? getProfilePic() => _getBox().get('profilePic');
  static bool getGeneralNotification() =>
      _getBox().get('generalNotification', defaultValue: true) as bool;
  static bool getOrderNotification() =>
      _getBox().get('orderNotification', defaultValue: true) as bool;
  static bool getEmailNotification() =>
      _getBox().get('emailNotification', defaultValue: false) as bool;

  // ─── Onboarding ──────────────────────────────────────
  static bool getOnboardingDone() =>
      _getBox().get('onboardingDone', defaultValue: false) as bool;
  static Future<void> setOnboardingDone() =>
      _getBox().put('onboardingDone', true);

  // ─── Logout ──────────────────────────────────────────
  static Future<void> clearAll() async {
    final onboardingDone = getOnboardingDone();
    await _getBox().clear();
    // preserve onboarding flag so user doesn't see onboarding again
    await _getBox().put('onboardingDone', onboardingDone);
  }
}
