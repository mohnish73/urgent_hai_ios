class RideHistoryResponse {
  final String message;
  final bool result;
  final List<RideHistoryData> data;

  RideHistoryResponse({
    required this.message,
    required this.result,
    required this.data,
  });

  factory RideHistoryResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['Data'];
    return RideHistoryResponse(
      message: json['Message'] ?? '',
      result: json['Result'] ?? false,
      data: raw is List
          ? raw.map((e) => RideHistoryData.fromJson(e)).toList()
          : [],
    );
  }
}

class RideHistoryData {
  final int riderBook;
  final String rideStatus;
  final int userId;
  final String mobileNo;
  final RideLocation pickupLocation;
  final RideLocation dropoffLocation;
  final String dateTime;
  final int rideTypeId;
  final double rideTypeFare;
  final bool isActive;
  final RideDriver driver;
  final RidePayment payment;

  RideHistoryData({
    required this.riderBook,
    required this.rideStatus,
    required this.userId,
    required this.mobileNo,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.dateTime,
    required this.rideTypeId,
    required this.rideTypeFare,
    required this.isActive,
    required this.driver,
    required this.payment,
  });

  factory RideHistoryData.fromJson(Map<String, dynamic> json) {
    return RideHistoryData(
      riderBook: json['riderBook'] ?? 0,
      rideStatus: json['rideStatus'] ?? '',
      userId: json['userID'] ?? 0,
      mobileNo: json['mobileNo'] ?? '',
      pickupLocation: RideLocation.fromJson(json['pickupLocation'] ?? {}),
      dropoffLocation: RideLocation.fromJson(json['dropoffLocation'] ?? {}),
      dateTime: json['dateTime'] ?? '',
      rideTypeId: json['rideTypeId'] ?? 0,
      rideTypeFare: (json['rideTypeFare'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? false,
      driver: RideDriver.fromJson(json['driver'] ?? {}),
      payment: RidePayment.fromJson(json['payment'] ?? {}),
    );
  }
}

class RideLocation {
  final String address;
  final double lat;
  final double lng;

  RideLocation({required this.address, required this.lat, required this.lng});

  factory RideLocation.fromJson(Map<String, dynamic> json) => RideLocation(
        address: json['address'] ?? '',
        lat: (json['lat'] ?? 0).toDouble(),
        lng: (json['lng'] ?? 0).toDouble(),
      );
}

class RideDriver {
  final String driverName;
  final String vehicleNo;
  final String driverImage;
  final String driverRating;
  final String driverNo;

  RideDriver({
    required this.driverName,
    required this.vehicleNo,
    required this.driverImage,
    required this.driverRating,
    required this.driverNo,
  });

  factory RideDriver.fromJson(Map<String, dynamic> json) => RideDriver(
        driverName: json['driverName'] ?? '',
        vehicleNo: json['DriverVehicleNo'] ?? '',
        driverImage: json['driverImage'] ?? '',
        driverRating: json['driverRating'] ?? '',
        driverNo: json['driverNo'] ?? '',
      );
}

class RidePayment {
  final String paymentType;
  final bool paymentStatus;
  final String paymentMethod;

  RidePayment({
    required this.paymentType,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory RidePayment.fromJson(Map<String, dynamic> json) => RidePayment(
        paymentType: json['paymentType'] ?? '',
        paymentStatus: json['paymentStatus'] ?? false,
        paymentMethod: json['paymentMethod'] ?? '',
      );
}
