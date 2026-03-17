class OtpResponseModel {
  final String message;
  final String? description;
  final bool result;
  final OtpData? data;

  OtpResponseModel({
    required this.message,
    this.description,
    required this.result,
    this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      message: json['Message'] ?? '',
      description: json['Description'],
      result: json['Result'] ?? false,
      data: json['Data'] != null ? OtpData.fromJson(json['Data']) : null,
    );
  }
}

class OtpData {
  final String id;
  final String otpValue;

  OtpData({required this.id, required this.otpValue});

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      id: json['ID']?.toString() ?? '',
      otpValue: json['OTPValue']?.toString() ?? '',
    );
  }
}
