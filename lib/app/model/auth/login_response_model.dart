class LoginResponseModel {
  final String message;
  final String? description;
  final bool result;
  final UserData? data;

  LoginResponseModel({
    required this.message,
    this.description,
    required this.result,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['Message'] ?? '',
      description: json['Description'],
      result: json['Result'] ?? false,
      data: json['Data'] != null ? UserData.fromJson(json['Data']) : null,
    );
  }
}

class UserData {
  final int pkUserId;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final String? emailId;
  final String? address;
  final String? profilePic;
  final String dateOfBirth;
  final String gender;
  final bool generalNotification;
  final bool orderNotification;
  final bool emailNotification;
  final bool isActive;

  UserData({
    required this.pkUserId,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    this.emailId,
    this.address,
    this.profilePic,
    required this.dateOfBirth,
    required this.gender,
    required this.generalNotification,
    required this.orderNotification,
    required this.emailNotification,
    required this.isActive,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      pkUserId: json['PK_User_Id'] ?? 0,
      firstName: json['First_Name'] ?? '',
      lastName: json['Last_Name'] ?? '',
      mobileNo: json['Mobile_No'] ?? '',
      emailId: json['Email_Id'],
      address: json['Address'],
      profilePic: json['Profile_pic'],
      dateOfBirth: json['Date_Of_Birth'] ?? '',
      gender: json['Gender'] ?? '',
      generalNotification: json['GeneralNotification'] ?? false,
      orderNotification: json['OrderNotification'] ?? false,
      emailNotification: json['EmailNotification'] ?? false,
      isActive: json['IsActive'] ?? false,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}
