import 'dart:convert';
import 'dart:developer';

import 'package:core_module/core_module.dart';
import 'package:dependencies_module/external/collection.dart';
import 'package:dependencies_module/external/local_auth/local_auth.dart';
import 'package:dependencies_module/external/local_auth/local_auth_android.dart';
import 'package:flutter/services.dart';

class AuthenticatorProvider {
  static final _localAuthentication = LocalAuthentication();
  static final _secureStorageProvider = SecureStorageProvider();

  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = <BiometricType>[];
  bool _authorized = false;
  bool _isAuthenticating = false;

  bool get isAuthenticating => _isAuthenticating;

  Future<bool> isBiometricAvailable() async {
    log("Checking biometrics...");
    bool isSupported = false;
    try {
      isSupported = await _localAuthentication.isDeviceSupported();
      log("Device has biometrics: $isSupported");
      _canCheckBiometrics =
          isSupported
              ? await _localAuthentication.canCheckBiometrics
              : isSupported;
    } on PlatformException catch (e) {
      _canCheckBiometrics = false;
      log("", error: "Error checking biometrics: $e");
    }
    if (isSupported) {
      log("Biometrics available: $_canCheckBiometrics");
    }
    if (_canCheckBiometrics) {
      await getListOfBiometricTypes();
    }
    return _canCheckBiometrics;
  }

  Future<List<BiometricType>> getListOfBiometricTypes() async {
    try {
      _availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      _availableBiometrics = <BiometricType>[];
      log("", error: "Error retrieving biometrics types: $e");
    }
    log("Biometrics types availables: $_availableBiometrics");
    return _availableBiometrics;
  }

  Future<void> cancelAuthentication() async {
    await _localAuthentication.stopAuthentication();
    _isAuthenticating = false;
    log("Authentication canceled");
  }

  Future<bool> authenticateUser({
    String? cancelButtonLabel,
    String? titleLabel,
    String? messageText,
  }) async {
    try {
      _isAuthenticating = true;
      _authorized = await _localAuthentication.authenticate(
        localizedReason: titleLabel ?? 'Biometrics authentication required!',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: messageText ?? 'Biometrics authentication required!',
            cancelButton: cancelButtonLabel ?? 'Cancel',
            biometricHint: "",
          ),
        ],
      );
      _isAuthenticating = false;
    } on PlatformException catch (e) {
      log("", error: "Error authenticating user: $e");
      _isAuthenticating = false;
      _authorized = false;
    }
    log("User authenticate: $_authorized");
    return _authorized;
  }

  Future<void> saveUserData(UserDataModel userData) async {
    final usersDataStorage = await _secureStorageProvider.readValue(
      SecureStorageKeys.usersData,
    );

    if (usersDataStorage == null) {
      final users = [userData.toJson()];

      return _secureStorageProvider.writeValue(
        SecureStorageKeys.usersData,
        jsonEncode(users),
      );
    }

    final users = json.decode(usersDataStorage) as List;

    final indexUser = users.indexWhere((item) {
      final user = UserDataModel.fromMap(jsonDecode(item));
      return user.userId == userData.userId;
    });

    if (!indexUser.isNegative) users.removeAt(indexUser);

    if (userData.isActive && users.isNotEmpty) {
      final user = users.firstWhereOrNull(
        (e) => jsonDecode(e)['isActive'] == true,
      );

      if (user != null) {
        final previousActiveUser = UserDataModel.fromMap(jsonDecode(user));

        final indexUser = users.indexWhere(
          (i) => jsonDecode(i)['isActive'] == true,
        );

        users.removeAt(indexUser);

        users.insert(
          indexUser,
          previousActiveUser.copyWith(isActive: false).toJson(),
        );
      }
    }

    if (indexUser.isNegative) {
      users.add(userData.toJson());
    } else {
      users.insert(indexUser, userData.toJson());
    }

    await _secureStorageProvider.writeValue(
      SecureStorageKeys.usersData,
      jsonEncode(users),
    );
  }

  Future<void> saveUserPassword(String password) async {
    await _secureStorageProvider.writeValue(
      SecureStorageKeys.userPassword,
      password,
    );
  }

  Future<String?> getUserPassword() async {
    return await _secureStorageProvider.readValue(
      SecureStorageKeys.userPassword,
    );
  }

  Future<UserDataModel?> getActiveUserData() async {
    final usersDataStorage = await _secureStorageProvider.readValue(
      SecureStorageKeys.usersData,
    );

    if (usersDataStorage == null) return null;

    final usersData =
        (jsonDecode(usersDataStorage) as List)
            .map((e) => UserDataModel.fromMap(jsonDecode(e)))
            .toList();

    return usersData.firstWhereOrNull((item) => item.isActive);
  }

  Future<List<UserDataModel>?> getListOfUsers() async {
    final usersDataStorage = await _secureStorageProvider.readValue(
      SecureStorageKeys.usersData,
    );

    if (usersDataStorage == null) return null;

    final usersData =
        (jsonDecode(usersDataStorage) as List)
            .map((e) => UserDataModel.fromMap(jsonDecode(e)))
            .toList();

    return usersData;
  }

  Future<void> setActiveUser(String userId) async {
    final users = await getListOfUsers();

    if (users == null) return;

    await Future.forEach<UserDataModel>(
      users,
      (user) async =>
          await saveUserData(user.copyWith(isActive: user.userId == userId)),
    );
  }

  Future<void> logoutAllUsers() async {
    try {
      final hasUser = await getActiveUserData();

      if (hasUser == null) return;

      await _secureStorageProvider.deleteAllValues();

      await navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> clearAllUsers() async {
    return _secureStorageProvider.deleteValue(SecureStorageKeys.usersData);
  }

  Future<void> clearUser(String userId) async {
    final usersDataStorage = await _secureStorageProvider.readValue(
      SecureStorageKeys.usersData,
    );

    if (usersDataStorage == null) return;

    final usersData = json.decode(usersDataStorage) as List;

    usersData.removeWhere((item) {
      final user = UserDataModel.fromMap(jsonDecode(item));
      return user.userId == userId;
    });

    await _secureStorageProvider.writeValue(
      SecureStorageKeys.usersData,
      jsonEncode(usersData),
    );
  }
}
