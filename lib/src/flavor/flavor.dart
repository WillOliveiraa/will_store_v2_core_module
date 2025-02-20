import 'package:flutter/material.dart';

enum Flavor { dev, qa, prod }

class FlavorValues {
  final String? baseUrl;
  final bool debug;
  final String date = "2025-02-20";
  final String version = "0.4.9";
  final int backgroundMinutesTimeout;
  final bool apiMock;

  //Add other flavor specific values, e.g database name
  FlavorValues({
    required this.baseUrl,
    required this.backgroundMinutesTimeout,
    this.debug = false,
    this.apiMock = false,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final String flavorName;
  final Color color;
  final FlavorValues values;

  FlavorConfig._internal(this.flavor, this.flavorName, this.color, this.values);

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
    Color color = Colors.blue,
  }) {
    return _instance ??= FlavorConfig._internal(
      flavor,
      _getName(flavor),
      color,
      values,
    );
  }

  static FlavorConfig? _instance;

  static FlavorConfig get instance => _instance!;

  static bool isProduction() => instance.flavor == Flavor.prod;
  static bool isDevelopment() => instance.flavor == Flavor.dev;
  static bool isQA() => instance.flavor == Flavor.qa;

  static Map<String, dynamic> getFlavorValues() => {
    "baseUrl": _instance?.values.baseUrl,
    "debug": _instance?.values.debug,
    "version": _instance?.values.version,
    "color": _instance?.color,
    "flavor": _instance?.flavorName,
  };

  static String _getName(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return 'Dev';
      case Flavor.qa:
        return 'QA';
      case Flavor.prod:
        return 'Prod';
    }
  }
}
