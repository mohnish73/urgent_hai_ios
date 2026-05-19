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

class AddAddressRequest {
  final int pkAddressId;
  final int fkUserId;
  final String userName;
  final String role;
  final String email;
  final String phoneNo;
  final String address;
  final String zipCode;
  final String city;
  final String country;
  final String lat;
  final String lng;
  final String apiAddress;
  final String addressType;
  final String createdDate;

  const AddAddressRequest({
    this.pkAddressId = 0,
    required this.fkUserId,
    required this.userName,
    this.role = 'User',
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.zipCode,
    required this.city,
    this.country = 'India',
    required this.lat,
    required this.lng,
    required this.apiAddress,
    required this.addressType,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
        'PK_AddressId': pkAddressId,
        'FK_User_Id': fkUserId,
        'UserName': userName,
        'Role': role,
        'Email': email,
        'PhoneNo': phoneNo,
        'Address': address,
        'ZipCode': zipCode,
        'City': city,
        'Country': country,
        'Lat': lat,
        'Long': lng,
        'ApiAddress': apiAddress,
        'AddressType': addressType,
        'CreatedDate': createdDate,
      };
}

class AddAddressResponse {
  final String message;
  final bool result;

  AddAddressResponse({required this.message, required this.result});

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) =>
      AddAddressResponse(
        message: json['Message'] ?? '',
        result: json['Result'] ?? false,
      );
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
