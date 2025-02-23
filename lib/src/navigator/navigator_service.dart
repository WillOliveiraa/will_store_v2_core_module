import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core_module.dart';

class NavigatorService {
  String? get microAppRoute => StackRoutes.microAppRoute;
  String? get globalRoute => StackRoutes.globalRoute;

  BuildContext get context => navigatorKey.currentState!.context;

  Future<T?> push<T extends Object?>(BuildContext context, String route,
      {Object? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final isPublicRoute =
        BaseApp.routes.any((microAppRoute) => microAppRoute.name == route);

    if (isPublicRoute) {
      return navigatorKey.currentState!.pushNamed<T>(route, arguments: params);
    }
    return Navigator.pushNamed<T>(context, route, arguments: params);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      BuildContext context, String route,
      {Object? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final isPublicRoute =
        BaseApp.routes.any((microAppRoute) => microAppRoute.name == route);

    if (isPublicRoute) {
      return navigatorKey.currentState!
          .pushReplacementNamed<T, TO>(route, arguments: params);
    }

    return Navigator.pushReplacementNamed<T, TO>(
      context,
      route,
      arguments: params,
    );
  }

  Future<T?> pushReplacementAndRemoveUntil<T extends Object?>(
      BuildContext context,
      String route,
      bool Function(Route<dynamic>) predicate,
      {Object? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final isPublicRoute =
        BaseApp.routes.any((microAppRoute) => microAppRoute.name == route);

    if (isPublicRoute) {
      return navigatorKey.currentState!
          .pushNamedAndRemoveUntil<T>(route, predicate, arguments: params);
    }

    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      route,
      predicate,
      arguments: params,
    );
  }

  Future<void> open(BuildContext context, String route, {Object? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final isPublicRoute =
        BaseApp.routes.any((microAppRoute) => microAppRoute.name == route);

    if (isPublicRoute) {
      return navigatorKey.currentState!
          .pushNamedAndRemoveUntil(route, (route) => false, arguments: params);
    }

    return Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
      arguments: params,
    );
  }

  void pop<T extends Object?>(BuildContext context, {T? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final canPop = Navigator.of(context).canPop();

    if (canPop) return Navigator.of(context).pop<T>(params);

    final globalCanPop = navigatorKey.currentState?.canPop();

    if (globalCanPop == true) {
      navigatorKey.currentState?.pop<T?>(params);
    }
  }

  void popUntil<T extends Object?>(BuildContext context, {T? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (params == null) {
      Navigator.of(context, rootNavigator: false)
          .popUntil((route) => route.isFirst);

      return;
    }

    while (StackRoutes.currentHistoryRoute.length > 2) {
      Navigator.pop(context);
    }

    Navigator.maybePop(context, params);
  }

  void popMicroApp<T extends Object?>(BuildContext context, {T? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    Navigator.of(context, rootNavigator: true).pop<T?>(params);
  }

  void popMicroAppUntil<T extends Object?>(BuildContext context, {T? params}) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
  }
}

class StackRoutes {
  static List<List<String>> currentHistoryRoute = [];
  static String? microAppRoute;
  static String? globalRoute;

  StackRoutes._();
}
