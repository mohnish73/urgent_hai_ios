import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/storage/hive_service.dart';
import '../model/auth/login_response_model.dart';
import '../model/auth/otp_response_model.dart';
import '../model/auth/signup_model.dart';
import '../repo/auth_repo.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepo();

  AuthStatus _status = AuthStatus.idle;
  String _errorMessage = '';
  OtpData? _otpData;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  OtpData? get otpData => _otpData;
  bool get isLoading => _status == AuthStatus.loading;

  // ─── Generate OTP ─────────────────────────────────────
  Future<bool> generateOtp(String phone) async {
    _setStatus(AuthStatus.loading);
    try {
      final res = await _repo.generateOtp(phone);
      if (res.result && res.data != null) {
        _otpData = res.data;
        _setStatus(AuthStatus.success);
        return true;
      } else {
        _setError(res.message.isNotEmpty ? res.message : 'Failed to send OTP');
        return false;
      }
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  // ─── Verify OTP ───────────────────────────────────────
  Future<bool> verifyOtp({
    required String id,
    required String otp,
    required String phone,
  }) async {
    _setStatus(AuthStatus.loading);
    try {
      final res = await _repo.verifyOtp(id: id, otp: otp, phone: phone);
      if (res.result && res.data != null) {
        await HiveService.saveUserData(res.data!);
        _setStatus(AuthStatus.success);
        return true;
      } else {
        _setError(res.message.isNotEmpty ? res.message : 'OTP verification failed');
        return false;
      }
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  // ─── Sign Up ──────────────────────────────────────────
  Future<int?> signUp(SignUpRequestModel request) async {
    _setStatus(AuthStatus.loading);
    try {
      final res = await _repo.signUp(request);
      if (res.result && res.data != null) {
        _setStatus(AuthStatus.success);
        return res.data!.pkUserId;
      } else {
        _setError(res.message.isNotEmpty ? res.message : 'Registration failed');
        return null;
      }
    } catch (e) {
      _setError(_parseError(e));
      return null;
    }
  }

  // ─── Get Profile (post signup) ────────────────────────
  Future<bool> getProfile({required int userId, required String phone}) async {
    _setStatus(AuthStatus.loading);
    try {
      final res = await _repo.getProfile(userId: userId, phone: phone);
      if (res.result && res.data != null) {
        await HiveService.saveUserData(res.data!);
        _setStatus(AuthStatus.success);
        return true;
      } else {
        _setError(res.message.isNotEmpty ? res.message : 'Failed to load profile');
        return false;
      }
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  // ─── Resend OTP (re-uses generateOtp) ─────────────────
  Future<bool> resendOtp(String phone) => generateOtp(phone);

  // ─── Reset ────────────────────────────────────────────
  void resetStatus() {
    _status = AuthStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }

  // ─── Helpers ──────────────────────────────────────────
  void _setStatus(AuthStatus s) {
    _status = s;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = AuthStatus.error;
    _errorMessage = msg;
    notifyListeners();
  }

  String _parseError(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Connection timeout. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
