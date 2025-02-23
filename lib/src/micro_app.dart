import 'package:core_module/core_module.dart';
import 'package:flutter/foundation.dart';

import './navigator/navigator_service.dart';

abstract class MicroApp extends BaseRouter {
  const MicroApp({required Key? key, required String? initialRoute})
      : super(key: key, initialRoute: initialRoute);

  String get path;

  String get microAppName;

  List<MicroAppRoute> get publicRoutes;

  void Function() get injectionsRegister;

  MicroApp copyWith({String? initialRoute});
}

NavigatorService get navigator => NavigatorService();
