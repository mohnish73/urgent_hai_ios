class AddressListResponse {
  final String message;
  final bool result;
  final List<AddressData> data;

  AddressListResponse({
    required this.message,
    required this.result,
    required this.data,
  });

  factory AddressListResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['Data'];
    return AddressListResponse(
      message: json['Message'] ?? '',
      result: json['Result'] ?? false,
      data: raw is List
          ? raw.map((e) => AddressData.fromJson(e)).toList()
          : [],
    );
  }
}

class AddressData {
  final int pkAddressId;
  final int fkUserId;
  final String userName;
  final String email;
  final String phoneNo;
  final String address;
  final String zipCode;
  final String city;
  final String country;
  final bool isPrimaryAddress;
  final bool isActive;
  final String addressType;
  final String lat;
  final String lng;

  AddressData({
    required this.pkAddressId,
    required this.fkUserId,
    required this.userName,
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.zipCode,
    required this.city,
    required this.country,
    required this.isPrimaryAddress,
    required this.isActive,
    required this.addressType,
    required this.lat,
    required this.lng,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        pkAddressId: json['PK_AddressId'] ?? 0,
        fkUserId: json['FK_User_Id'] ?? 0,
        userName: json['UserName'] ?? '',
        email: json['Email'] ?? '',
        phoneNo: json['PhoneNo'] ?? '',
        address: json['Address'] ?? '',
        zipCode: json['ZipCode'] ?? '',
        city: json['City'] ?? '',
        country: json['Country'] ?? '',
        isPrimaryAddress: json['IsPrimaryAddress'] ?? false,
        isActive: json['IsActive'] ?? false,
        addressType: json['AddressType'] ?? '',
        lat: json['Lat'] ?? '',
        lng: json['Long'] ?? '',
      );
}
