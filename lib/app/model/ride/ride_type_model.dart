class RideTypeResponse {
  final String message;
  final bool result;
  final List<RideTypeData> data;

  RideTypeResponse({
    required this.message,
    required this.result,
    required this.data,
  });

  factory RideTypeResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['Data'];
    List<RideTypeData> rides = [];

    if (raw is Map<String, dynamic>) {
      // API returns Data: { requestedId: ..., rides: [...] }
      final rawRides = raw['rides'];
      if (rawRides is List) {
        rides = rawRides
            .map((e) => RideTypeData.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } else if (raw is List) {
      rides = raw
          .map((e) => RideTypeData.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return RideTypeResponse(
      message: json['Message'] ?? '',
      result: json['Result'] ?? false,
      data: rides,
    );
  }
}

class RideTypeData {
  final int rideTypeId;
  final String rideTypeName;
  final String rideTypeDesc;
  final double rideTypeFare;
  final int rideTypeSeats;
  final String rideTypeImage;

  RideTypeData({
    required this.rideTypeId,
    required this.rideTypeName,
    required this.rideTypeDesc,
    required this.rideTypeFare,
    required this.rideTypeSeats,
    required this.rideTypeImage,
  });

  factory RideTypeData.fromJson(Map<String, dynamic> json) => RideTypeData(
        rideTypeId: json['rideTypeId'] ?? 0,
        rideTypeName: json['rideTypeName'] ?? '',
        // API field is 'rideTypeDescription'
        rideTypeDesc: json['rideTypeDescription'] ?? json['rideTypeDesc'] ?? '',
        rideTypeFare: (json['rideTypeFare'] ?? 0).toDouble(),
        // API field is 'rideTypeSeat'
        rideTypeSeats: json['rideTypeSeat'] ?? json['rideTypeSeats'] ?? 0,
        rideTypeImage: json['rideTypeImage'] ?? '',
      );
}
