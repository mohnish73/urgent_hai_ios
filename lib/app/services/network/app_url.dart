import '../../core/config/app_config.dart';

class AppUrl {
  static const String _base = AppConfig.baseUrl;

  // ─── Auth ─────────────────────────────────────────────
  static const String generateOtp = '${_base}URGH/GenerateOTP';
  static const String authenticateLogin = '${_base}URGH/AuthenticateLogin';
  static const String versionCheck = '${_base}URGH/VersionCheck';

  // ─── User ─────────────────────────────────────────────
  static const String getUserProfile = '${_base}URGH/GetUserProfile';
  static const String registerNewUser = '${_base}URGH/AddRegisterNewUser';
  static const String updateUserProfile = '${_base}URGH/UpdateUserProfile';

  // ─── Address ──────────────────────────────────────────
  static const String getUserAddressList = '${_base}URGH/GetUserAddressList';
  static const String addUserNewAddress = '${_base}URGH/AddUserNewAddress';
  static const String deleteUserAddress = '${_base}URGH/DeleteUserAddress';

  // ─── Ride ─────────────────────────────────────────────
  static const String getRideType = '${_base}URGH/GetRideType';
  static const String bookingRequestByUser = '${_base}URGH/BookingRequestByUser';
  static const String getUserRideList = '${_base}URGH/GetUserRideListByUserId';
  static const String checkBooking = '${_base}URGH/CheckBooking';
  static const String cancelRideByUser = '${_base}URGH/CancelRideByUser';
  static const String cancelRideFromTemp = '${_base}URGH/CancelRideFromTempFromUser';

  // ─── Parcel ───────────────────────────────────────────
  static const String saveParcelDescription = '${_base}URGH/SaveParcelDescription';

  // ─── Store ────────────────────────────────────────────
  static const String getProductById = '${_base}URGH/GetProductByProductId';
}
