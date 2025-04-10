import 'dart:convert';

import './access_token_model.dart';

class UserDataModel {
  final AccessTokenModel accessToken;
  final String userId;
  final String? pin;
  final bool hasBiometrics;
  final bool isActive;

  UserDataModel({
    required this.accessToken,
    required this.userId,
    this.pin,
    required this.hasBiometrics,
    required this.isActive,
  });

  UserDataModel copyWith({
    AccessTokenModel? accessToken,
    String? userId,
    String? pin,
    bool? hasBiometrics,
    bool? isActive,
  }) {
    return UserDataModel(
      accessToken: accessToken ?? this.accessToken,
      userId: userId ?? this.userId,
      pin: pin ?? this.pin,
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      isActive: isActive ?? this.isActive,
    );
  }

  factory UserDataModel.empty() {
    return UserDataModel(
      accessToken: AccessTokenModel.empty(),
      userId: '',
      pin: '',
      hasBiometrics: false,
      isActive: false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken.toMap(),
      'userId': userId,
      'pin': pin,
      'hasBiometrics': hasBiometrics,
      'isActive': isActive,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      accessToken: AccessTokenModel.fromMap(
        map['accessToken'] as Map<String, dynamic>,
      ),
      userId: map['userId'] as String,
      pin: map['pin'] as String?,
      hasBiometrics: map['hasBiometrics'] as bool,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserDataModel other) {
    if (identical(this, other)) return true;

    return other.accessToken == accessToken &&
        other.userId == userId &&
        other.pin == pin &&
        other.hasBiometrics == hasBiometrics &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^
        userId.hashCode ^
        pin.hashCode ^
        hasBiometrics.hashCode ^
        isActive.hashCode;
  }
}
