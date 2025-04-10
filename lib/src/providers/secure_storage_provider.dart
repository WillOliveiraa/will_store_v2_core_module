import 'package:dependencies_module/external/flutter_secure_storage.dart';

enum SecureStorageKeys {
  usersData('users_data'),
  pin('pin');

  final String name;
  const SecureStorageKeys(this.name);
}

class SecureStorageProvider {
  final secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<String?> readValue(SecureStorageKeys key) {
    return secureStorage.read(key: key.name);
  }

  Future<void> deleteValue(SecureStorageKeys key) {
    return secureStorage.delete(key: key.name);
  }

  Future<void> writeValue(SecureStorageKeys key, String value) {
    return secureStorage.write(key: key.name, value: value);
  }

  Future<void> deleteAllValues() {
    return secureStorage.deleteAll();
  }
}
