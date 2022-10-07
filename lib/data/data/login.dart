class LoginResponse {
  final String accessToken;
  final String expiresIn;

  LoginResponse({
    required this.accessToken,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'].toString(),
      expiresIn: json['expires_in'].toString(),
    );
  }
}