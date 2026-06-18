class ParcelRequestModel {
  final int userId;
  final String userMobileNumber;
  int bookingId;
  final ParcelSenderModel sender;
  final ParcelReceiverModel receiver;
  final ParcelInfoModel parcelInfo;

  ParcelRequestModel({
    required this.userId,
    required this.userMobileNumber,
    this.bookingId = 0,
    required this.sender,
    required this.receiver,
    required this.parcelInfo,
  });

  Map<String, dynamic> toJson() => {
        'UserId': userId,
        'UserMobileNumber': userMobileNumber,
        'BookingId': bookingId,
        'Sender': sender.toJson(),
        'Receiver': receiver.toJson(),
        'ParcelInfo': parcelInfo.toJson(),
      };
}

class ParcelSenderModel {
  final String name;
  final String mobileNumber;
  final bool isSending;

  const ParcelSenderModel({
    required this.name,
    required this.mobileNumber,
    required this.isSending,
  });

  Map<String, dynamic> toJson() => {
        'Name': name,
        'MobileNumber': mobileNumber,
        'IsSending': isSending,
      };
}

class ParcelReceiverModel {
  final String name;
  final String mobileNumber;
  final bool isReceiving;

  const ParcelReceiverModel({
    required this.name,
    required this.mobileNumber,
    required this.isReceiving,
  });

  Map<String, dynamic> toJson() => {
        'Name': name,
        'MobileNumber': mobileNumber,
        'IsReceiving': isReceiving,
      };
}

class ParcelInfoModel {
  final int height;
  final int width;
  final double weightKg;

  const ParcelInfoModel({
    required this.height,
    required this.width,
    required this.weightKg,
  });

  Map<String, dynamic> toJson() => {
        'Height': height,
        'Width': width,
        'WeightKg': weightKg,
      };
}

class ParcelSaveResponse {
  final bool result;
  final String message;

  ParcelSaveResponse({required this.result, required this.message});

  factory ParcelSaveResponse.fromJson(Map<String, dynamic> json) =>
      ParcelSaveResponse(
        result: json['Result'] ?? false,
        message: json['Message'] ?? '',
      );
}
