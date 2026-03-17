class SignUpRequestModel {
  final int pkUserId;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final String dateOfBirth;
  final String gender;
  final String email;
  final bool generalNotification;
  final bool orderNotification;
  final bool emailNotification;

  SignUpRequestModel({
    this.pkUserId = 0,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    this.generalNotification = true,
    this.orderNotification = true,
    this.emailNotification = false,
  });

  Map<String, dynamic> toJson() => {
        'PK_User_Id': pkUserId,
        'First_Name': firstName,
        'Last_Name': lastName,
        'Mobile_No': mobileNo,
        'Date_Of_Birth': dateOfBirth,
        'Gender': gender,
        'Email': email,
        'GeneralNotification': generalNotification,
        'OrderNotification': orderNotification,
        'EmailNotification': emailNotification,
      };
}

class SignUpResponseModel {
  final String message;
  final String? description;
  final bool result;
  final SignUpData? data;

  SignUpResponseModel({
    required this.message,
    this.description,
    required this.result,
    this.data,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      message: json['Message'] ?? '',
      description: json['Description'],
      result: json['Result'] ?? false,
      data: json['Data'] != null ? SignUpData.fromJson(json['Data']) : null,
    );
  }
}

class SignUpData {
  final int pkUserId;

  SignUpData({required this.pkUserId});

  factory SignUpData.fromJson(Map<String, dynamic> json) {
    return SignUpData(pkUserId: json['PK_User_Id'] ?? 0);
  }
}
