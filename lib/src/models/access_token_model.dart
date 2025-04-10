import 'dart:convert';

class AccessTokenModel {
  final String accessToken;
  final String? expireTime;

  AccessTokenModel({required this.accessToken, this.expireTime});

  AccessTokenModel copyWith({String? accessToken, String? expireTime}) {
    return AccessTokenModel(
      accessToken: accessToken ?? this.accessToken,
      expireTime: expireTime ?? this.expireTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'expireTime': expireTime,
    };
  }

  factory AccessTokenModel.fromMap(Map<String, dynamic> map) {
    return AccessTokenModel(
      accessToken: map['accessToken'] as String,
      expireTime: map['expireTime'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessTokenModel.fromJson(String source) =>
      AccessTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory AccessTokenModel.empty() {
    return AccessTokenModel(accessToken: '', expireTime: '');
  }
}
