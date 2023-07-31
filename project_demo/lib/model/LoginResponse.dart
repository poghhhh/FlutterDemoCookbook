class TokenModel {
  String access_token;
  String refresh_token;

  TokenModel({required this.access_token, required this.refresh_token});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
        access_token: json['access_token'],
        refresh_token: json['refresh_token']);
  }
}
