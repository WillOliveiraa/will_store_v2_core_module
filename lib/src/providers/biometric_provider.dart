import 'package:dependencies_module/external/local_auth/local_auth.dart';

import '../../core_module.dart';

class BiometricsProvider {
  final AuthenticatorProvider authenticatorProvider;
  final LocalStorageProvider localStorageProvider;

  BiometricsProvider(this.authenticatorProvider, this.localStorageProvider);

  Future<bool> authenticate({
    String? title,
    String? message,
    String? cancelLabel,
  }) async {
    return await authenticatorProvider.authenticateUser(
      titleLabel: title,
      messageText: message,
      cancelButtonLabel: cancelLabel,
    );
  }

  Future<bool> isBiometricAvailable() async {
    return authenticatorProvider.isBiometricAvailable();
  }

  Future<List<BiometricType>> getListOfBiometricTypes() async {
    return await authenticatorProvider.getListOfBiometricTypes();
  }

  void saveListToLocalStorage(List<BiometricType> availableBiometrics) {
    if (availableBiometrics.isNotEmpty) {
      saveListLocalStorage(
        convertListBiometricsToStringList(availableBiometrics),
      );
    }
  }

  void saveListLocalStorage(List<String> value) {
    localStorageProvider.savePersistentListString(
      LocalStorageKeys.biometricTypes,
      value,
    );
  }

  List<String> convertListBiometricsToStringList(List<BiometricType> types) {
    return types.map((e) => e.name).toList();
  }
}
