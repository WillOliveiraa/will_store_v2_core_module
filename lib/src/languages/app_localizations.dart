import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'entities/languages_entity.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationDelagate();

  static AppLocalizations? of(context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  Map<String, dynamic>? _localisedString;

  Future<void> load() async {
    final pathJsonLocale =
        'packages/core_module/assets/languages/app_${locale.languageCode}.json';

    final jsonString = await rootBundle.loadString(pathJsonLocale);

    _localisedString = json.decode(jsonString);
  }

  String translate(String value, [Map<String, dynamic>? params]) {
    try {
      final moduleKey = value.split('.')[0];
      final searchKey = value.split('.')[1];

      final module = _localisedString?[moduleKey] as Map<String, dynamic>?;

      String? valueKey = module?[searchKey] as String?;

      if (valueKey != null) {
        params?.forEach((key, value) {
          final newValue = value != null ? value.toString() : '';
          valueKey = valueKey?.replaceAll('{$key}', newValue);
        });
      }

      return valueKey ?? '';
    } catch (e) {
      return '';
    }
  }
}

class _AppLocalizationDelagate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelagate();

  @override
  bool isSupported(Locale locale) {
    return Languages.languages
        .map((e) => e.code)
        .toList()
        .contains(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale);
    await appLocalizations.load();
    return appLocalizations;
  }
}
