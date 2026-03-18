class BookRideRequestModel {
  final String userId;
  final String mobileNo;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String dropAddress;
  final double dropLat;
  final double dropLng;
  final int rideTypeId;

  BookRideRequestModel({
    required this.userId,
    required this.mobileNo,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropAddress,
    required this.dropLat,
    required this.dropLng,
    required this.rideTypeId,
  });

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    final dateTime =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    return {
      'userID': userId,
      'mobileNo': mobileNo,
      'pickupLocation': {
        'address': pickupAddress,
        'latitude': pickupLat,
        'longitude': pickupLng,
      },
      'dropoffLocation': {
        'address': dropAddress,
        'latitude': dropLat,
        'longitude': dropLng,
      },
      'dateTime': dateTime,
      'rideTypeId': rideTypeId.toString(),
    };
  }
}

class BookRideResponse {
  final String message;
  final bool result;
  final BookRideData? data;

  BookRideResponse({required this.message, required this.result, this.data});

  factory BookRideResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['Data'];
    return BookRideResponse(
      message: json['Message'] ?? '',
      result: json['Result'] ?? false,
      data: raw is Map<String, dynamic> ? BookRideData.fromJson(raw) : null,
    );
  }
}

class BookRideData {
  final int riderBook;
  final int tempRideBookId; // used for checkBooking + cancel
  final String rideStatus;
  final String pickupAddress;
  final String dropAddress;
  final int rideTypeId;
  final double rideTypeFare;
  final String driverName;
  final String vehicleNo;
  final String driverRating;
  final String driverNo;
  final String otp;
  final int userId;

  BookRideData({
    required this.riderBook,
    required this.tempRideBookId,
    required this.rideStatus,
    required this.pickupAddress,
    required this.dropAddress,
    required this.rideTypeId,
    required this.rideTypeFare,
    required this.driverName,
    required this.vehicleNo,
    required this.driverRating,
    required this.driverNo,
    required this.otp,
    required this.userId,
  });

  factory BookRideData.fromJson(Map<String, dynamic> json) {
    // API returns nested pickupLocation / dropoffLocation objects
    String pickupAddress = '';
    String dropAddress = '';

    final pickupLoc = json['pickupLocation'];
    if (pickupLoc is Map<String, dynamic>) {
      pickupAddress = pickupLoc['address']?.toString() ?? '';
    } else {
      pickupAddress = json['PickupAddress'] ?? json['pickupAddress'] ?? '';
    }

    final dropLoc = json['dropoffLocation'];
    if (dropLoc is Map<String, dynamic>) {
      dropAddress = dropLoc['address']?.toString() ?? '';
    } else {
      dropAddress = json['DropAddress'] ?? json['dropAddress'] ?? '';
    }

    return BookRideData(
      riderBook: json['riderBook'] ?? json['tempridebookid'] ?? 0,
      tempRideBookId: json['tempridebookid'] ?? 0,
      rideStatus: json['rideStatus'] ?? (json['isActive'] == true ? 'Active' : ''),
      pickupAddress: pickupAddress,
      dropAddress: dropAddress,
      rideTypeId: json['rideTypeId'] ?? 0,
      rideTypeFare: (json['rideTypeFare'] ?? 0).toDouble(),
      driverName: json['driverName'] ?? '',
      vehicleNo: json['DriverVehicleNo'] ?? json['vehicleNo'] ?? '',
      driverRating: json['driverRating'] ?? '',
      driverNo: json['driverNo'] ?? '',
      otp: json['OTP']?.toString() ?? '',
      userId: json['userID'] ?? json['userId'] ?? 0,
    );
  }
}

class CheckBookingResponse {
  final String message;
  final bool result;
  final CheckBookingData? data;

  CheckBookingResponse({required this.message, required this.result, this.data});

  factory CheckBookingResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['Data'];
    return CheckBookingResponse(
      message: json['Message'] ?? '',
      result: json['Result'] ?? false,
      data: raw is Map<String, dynamic> ? CheckBookingData.fromJson(raw) : null,
    );
  }
}

class CheckBookingData {
  final bool isRideBook;
  final int bookingId;

  CheckBookingData({required this.isRideBook, required this.bookingId});

  factory CheckBookingData.fromJson(Map<String, dynamic> json) => CheckBookingData(
        isRideBook: json['IsRideBook'] ?? false,
        bookingId: json['BookingId'] ?? 0,
      );
}
