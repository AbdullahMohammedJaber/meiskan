import '../../core/enums/enums.dart';


class UserModel {
  final String id;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final AccountType type;

  UserModel({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_Id'] as String,
      fullName: json['full_Name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_Number'] as String?,
      type: json['role_Name'] == 'Owner'
          ? AccountType.owner
          : AccountType.contractor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_Id': id,
      'full_Name': fullName,
      'email': email,
      'phone_Number': phoneNumber,
      'role_Name': type == AccountType.owner ? 'Owner' : 'Contractor',
    };
  }
}
