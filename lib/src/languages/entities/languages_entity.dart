// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LanguageEntity {
  final String code;
  final String? value;
  final String? countryCode;

  const LanguageEntity({
    required this.code,
    this.value,
    this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'value': value,
      'countryCode': countryCode,
    };
  }

  factory LanguageEntity.fromMap(Map<String, dynamic> map) {
    return LanguageEntity(
      code: map['code'] as String,
      value: map['value'] != null ? map['value'] as String : null,
      countryCode:
          map['countryCode'] != null ? map['countryCode'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageEntity.fromJson(String source) =>
      LanguageEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Languages {
  const Languages._();

  static final languages = [
    LanguageEntity(
      code: getLanguageCode(SupportedLanguages.en),
      value: getLanguageName(SupportedLanguages.en),
      countryCode: getCountryCode(SupportedLanguages.en),
    ),
    LanguageEntity(
      code: getLanguageCode(SupportedLanguages.ptBr),
      value: getLanguageName(SupportedLanguages.ptBr),
      countryCode: getCountryCode(SupportedLanguages.ptBr),
    ),
  ];

  static String getLanguageCode(SupportedLanguages code) {
    switch (code) {
      case SupportedLanguages.en:
        return "en";
      case SupportedLanguages.ptBr:
        return "pt";
    }
  }

  static String getLanguageName(SupportedLanguages code) {
    switch (code) {
      case SupportedLanguages.en:
        return "English";
      case SupportedLanguages.ptBr:
        return "Portuguese_Br";
    }
  }

  static String getCountryCode(SupportedLanguages code) {
    switch (code) {
      case SupportedLanguages.en:
        return "EN";
      case SupportedLanguages.ptBr:
        return "BR";
    }
  }

  static LanguageEntity getLanguage(SupportedLanguages code) {
    return languages.firstWhere((el) => el.code == getLanguageCode(code));
  }

  static LanguageEntity getLanguageByCode(String code) {
    return languages.firstWhere((el) => el.code == code);
  }
}

enum SupportedLanguages { en, ptBr }
