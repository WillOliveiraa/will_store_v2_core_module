import 'dart:convert';

class AccessTokenModel {
  final String accessToken;
  final String deviceAccessToken;
  final String expireTime;

  AccessTokenModel({
    required this.accessToken,
    required this.deviceAccessToken,
    required this.expireTime,
  });

  AccessTokenModel copyWith({
    String? accessToken,
    String? deviceAccessToken,
    String? expireTime,
  }) {
    return AccessTokenModel(
      accessToken: accessToken ?? this.accessToken,
      deviceAccessToken: deviceAccessToken ?? this.deviceAccessToken,
      expireTime: expireTime ?? this.expireTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'deviceAccessToken': deviceAccessToken,
      'expireTime': expireTime,
    };
  }

  factory AccessTokenModel.fromMap(Map<String, dynamic> map) {
    return AccessTokenModel(
      accessToken: map['accessToken'] as String,
      deviceAccessToken: map['deviceAccessToken'] as String,
      expireTime: map['expireTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessTokenModel.fromJson(String source) =>
      AccessTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory AccessTokenModel.empty() {
    return AccessTokenModel(
      accessToken: '',
      deviceAccessToken: '',
      expireTime: '',
    );
  }
}
