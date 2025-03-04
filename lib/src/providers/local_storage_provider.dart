import 'package:dependencies_module/external/shared_preferences.dart';

enum LocalStorageKeys { themePreference, languagePreference, userId }

class LocalStorageProvider {
  Future<List<String>> getPersistentListString(LocalStorageKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(getLocalStorageKey(key)) ?? [];
  }

  Future<void> savePersistentListString(
      LocalStorageKeys key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(getLocalStorageKey(key), value);
  }

  Future<void> savePersistentString(LocalStorageKeys key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(getLocalStorageKey(key), value);
  }

  Future<String> getPersistentString(LocalStorageKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(getLocalStorageKey(key)) ?? '';
    return value;
  }

  Future<void> removePersistentItem(LocalStorageKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(getLocalStorageKey(key));
  }

  Future<void> savePersistentFlag(LocalStorageKeys key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(getLocalStorageKey(key), value);
  }

  Future<bool?> getPersistentFlag(LocalStorageKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(getLocalStorageKey(key));
  }

  String getLocalStorageKey(LocalStorageKeys key) {
    switch (key) {
      case LocalStorageKeys.themePreference:
        return "theme_preference";
      case LocalStorageKeys.languagePreference:
        return "language_preference";
      case LocalStorageKeys.userId:
        return "user_id";
      default:
        return '';
    }
  }
}
