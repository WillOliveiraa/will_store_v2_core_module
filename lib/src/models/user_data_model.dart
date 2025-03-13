import 'dart:convert';

import './access_token_model.dart';

class UserDataModel {
  final AccessTokenModel accessToken;
  final String clientId;
  final String userDevicePairingId;
  final String installationId;
  final String deviceInformation;
  final String deviceLanguage;
  final String pushDeviceToken;
  final String timestamp;
  final String pin;
  final String username;
  final String registUsername;
  final String iban;
  final String accountOpeningStatus;
  final String? photoUrl;
  final bool hasBiometrics;
  final bool isActive;

  UserDataModel({
    required this.accessToken,
    required this.clientId,
    required this.userDevicePairingId,
    required this.installationId,
    required this.deviceInformation,
    required this.deviceLanguage,
    required this.pushDeviceToken,
    required this.timestamp,
    required this.pin,
    required this.username,
    required this.registUsername,
    required this.iban,
    required this.accountOpeningStatus,
    required this.hasBiometrics,
    required this.isActive,
    this.photoUrl,
  });

  UserDataModel copyWith({
    AccessTokenModel? accessToken,
    String? clientId,
    String? userDevicePairingId,
    String? installationId,
    String? deviceInformation,
    String? deviceLanguage,
    String? pushDeviceToken,
    String? timestamp,
    String? pin,
    String? username,
    String? registUsername,
    String? iban,
    String? accountOpeningStatus,
    String? photoUrl,
    bool? hasBiometrics,
    bool? isActive,
  }) {
    return UserDataModel(
      accessToken: accessToken ?? this.accessToken,
      clientId: clientId ?? this.clientId,
      userDevicePairingId: userDevicePairingId ?? this.userDevicePairingId,
      installationId: installationId ?? this.installationId,
      deviceInformation: deviceInformation ?? this.deviceInformation,
      deviceLanguage: deviceLanguage ?? this.deviceLanguage,
      pushDeviceToken: pushDeviceToken ?? this.pushDeviceToken,
      timestamp: timestamp ?? this.timestamp,
      pin: pin ?? this.pin,
      username: username ?? this.username,
      registUsername: registUsername ?? this.registUsername,
      iban: iban ?? this.iban,
      accountOpeningStatus: accountOpeningStatus ?? this.accountOpeningStatus,
      photoUrl: photoUrl ?? this.photoUrl,
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      isActive: isActive ?? this.isActive,
    );
  }

  factory UserDataModel.empty() {
    return UserDataModel(
      accessToken: AccessTokenModel.empty(),
      clientId: '',
      userDevicePairingId: '',
      installationId: '',
      deviceInformation: '',
      deviceLanguage: '',
      pushDeviceToken: '',
      timestamp: '',
      pin: '',
      username: '',
      registUsername: '',
      iban: '',
      accountOpeningStatus: '',
      photoUrl: '',
      hasBiometrics: false,
      isActive: false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken.toMap(),
      'clientId': clientId,
      'userDevicePairingId': userDevicePairingId,
      'installationId': installationId,
      'deviceInformation': deviceInformation,
      'deviceLanguage': deviceLanguage,
      'pushDeviceToken': pushDeviceToken,
      'timestamp': timestamp,
      'pin': pin,
      'username': username,
      'registUsername': registUsername,
      'iban': iban,
      'accountOpeningStatus': accountOpeningStatus,
      "photoUrl": photoUrl,
      'hasBiometrics': hasBiometrics,
      'isActive': isActive,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      accessToken: AccessTokenModel.fromMap(
        map['accessToken'] as Map<String, dynamic>,
      ),
      clientId: map['clientId'] as String,
      userDevicePairingId: map['userDevicePairingId'] as String,
      installationId: map['installationId'] as String,
      deviceInformation: map['deviceInformation'] as String,
      deviceLanguage: map['deviceLanguage'] as String,
      pushDeviceToken: map['pushDeviceToken'] as String,
      timestamp: map['timestamp'] as String,
      pin: map['pin'] as String,
      username: map['username'] as String,
      registUsername: map['registUsername'] as String,
      iban: map['iban'] as String,
      accountOpeningStatus: map['accountOpeningStatus'] as String,
      photoUrl: map['photoUrl'] as String?,
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
        other.clientId == clientId &&
        other.userDevicePairingId == userDevicePairingId &&
        other.installationId == installationId &&
        other.deviceInformation == deviceInformation &&
        other.deviceLanguage == deviceLanguage &&
        other.pushDeviceToken == pushDeviceToken &&
        other.timestamp == timestamp &&
        other.pin == pin &&
        other.username == username &&
        other.registUsername == registUsername &&
        other.iban == iban &&
        other.accountOpeningStatus == accountOpeningStatus &&
        other.photoUrl == photoUrl &&
        other.hasBiometrics == hasBiometrics &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^
        clientId.hashCode ^
        userDevicePairingId.hashCode ^
        installationId.hashCode ^
        deviceInformation.hashCode ^
        deviceLanguage.hashCode ^
        pushDeviceToken.hashCode ^
        timestamp.hashCode ^
        pin.hashCode ^
        username.hashCode ^
        registUsername.hashCode ^
        iban.hashCode ^
        accountOpeningStatus.hashCode ^
        photoUrl.hashCode ^
        hasBiometrics.hashCode ^
        isActive.hashCode;
  }
}
