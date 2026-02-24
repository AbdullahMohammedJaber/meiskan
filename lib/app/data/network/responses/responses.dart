import '../../model/user.dart';

class AuthResponse {
  final String refreshToken;
  final String token;
  final UserModel user;

  AuthResponse({
    required this.refreshToken,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      refreshToken: json['refresh_Token'] as String,
      user: UserModel.fromJson(json),
    );
  }
}
