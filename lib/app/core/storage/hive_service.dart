import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';
import '../../model/auth/login_response_model.dart';
import '../../theme/app_constants.dart';

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
    await box.put(AppConstants.keyUserId, user.pkUserId.toString());
    await box.put(AppConstants.keyFirstName, user.firstName);
    await box.put(AppConstants.keyLastName, user.lastName);
    await box.put(AppConstants.keyMobileNo, user.mobileNo);
    await box.put(AppConstants.keyEmail, user.emailId ?? '');
    await box.put(AppConstants.keyGender, user.gender);
    await box.put(AppConstants.keyDateOfBirth, user.dateOfBirth);
    await box.put(AppConstants.keyProfilePic, user.profilePic ?? '');
    await box.put(AppConstants.keyGeneralNotification, user.generalNotification);
    await box.put(AppConstants.keyOrderNotification, user.orderNotification);
    await box.put(AppConstants.keyEmailNotification, user.emailNotification);
  }

  static String? getUserId() => _getBox().get(AppConstants.keyUserId);

  static String getFullName() {
    final first = _getBox().get(AppConstants.keyFirstName, defaultValue: '') as String;
    final last = _getBox().get(AppConstants.keyLastName, defaultValue: '') as String;
    return '$first $last'.trim();
  }

  static String? getFirstName() => _getBox().get(AppConstants.keyFirstName);
  static String? getLastName() => _getBox().get(AppConstants.keyLastName);
  static String? getMobileNo() => _getBox().get(AppConstants.keyMobileNo);
  static String? getEmail() => _getBox().get(AppConstants.keyEmail);
  static String? getGender() => _getBox().get(AppConstants.keyGender);
  static String? getDateOfBirth() => _getBox().get(AppConstants.keyDateOfBirth);
  static String? getProfilePic() => _getBox().get(AppConstants.keyProfilePic);

  static bool getGeneralNotification() =>
      _getBox().get(AppConstants.keyGeneralNotification, defaultValue: true) as bool;
  static bool getOrderNotification() =>
      _getBox().get(AppConstants.keyOrderNotification, defaultValue: true) as bool;
  static bool getEmailNotification() =>
      _getBox().get(AppConstants.keyEmailNotification, defaultValue: false) as bool;

  // ─── Onboarding ──────────────────────────────────────
  static bool getOnboardingDone() =>
      _getBox().get(AppConstants.keyOnboardingDone, defaultValue: false) as bool;
  static Future<void> setOnboardingDone() =>
      _getBox().put(AppConstants.keyOnboardingDone, true);

  // ─── Logout ──────────────────────────────────────────
  static Future<void> clearAll() async {
    final onboardingDone = getOnboardingDone();
    await _getBox().clear();
    await _getBox().put(AppConstants.keyOnboardingDone, onboardingDone);
  }
}
