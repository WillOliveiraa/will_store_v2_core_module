import 'dart:developer';

import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';

import './navigator/transitions/transitions.dart';

abstract class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  ///MicroApps are initialized in the [registerRoutes] method
  List<MicroApp> get microApps;

  List<MicroAppRoute> get baseRoutes;

  ///Routes that will be used in the base app
  static List<MicroAppRoute> routes = [];

  Widget builder(BuildContext context);

  ///Size of the phone in UI Design , dp
  Size get designSize;

  @override
  Widget build(BuildContext context) {
    return ScreenConfig(
      designSize: designSize,
      minTextAdapt: false,
      useInheritedMediaQuery: false,
      builder: (context) => builder(context),
    );
  }

  void registerRoutes() {
    if (baseRoutes.isNotEmpty) routes.addAll(baseRoutes);

    if (microApps.isNotEmpty) {
      for (MicroApp microApp in microApps) {
        final microAppRoute = MicroAppRoute(
          microApp.path,
          child: (_, args) => microApp,
        );

        routes.add(microAppRoute);

        for (MicroAppRoute publicRoute in microApp.publicRoutes) {
          var routeName = publicRoute.name;

          if (routeName != '/') {
            final microAppPublicRoute = MicroAppRoute(
              '${microApp.path}$routeName',
              child: (_, args) => microApp.copyWith(initialRoute: routeName),
              transitionType: publicRoute.transitionType,
              duration: publicRoute.duration,
              maintainState: publicRoute.maintainState,
              opaque: publicRoute.opaque,
            );
            routes.add(microAppPublicRoute);
          }
        }
      }
    }
    log("Public routes:");
    routes.forEach(_printRoute);
  }

  void registerInjections() {
    if (microApps.isNotEmpty) {
      for (MicroApp microApp in microApps) {
        microApp.injectionsRegister();
      }
    }
  }

  Route<dynamic>? generateRoute(BuildContext context, RouteSettings settings) {
    try {
      var routerName = settings.name;

      var microApp = routes.firstWhere((route) => route.name == routerName);

      return _createRoute(context, settings, microApp);
    } catch (e) {
      return null;
    }
  }

  void _printRoute(MicroAppRoute microAppRoute) {
    log(microAppRoute.name);
  }

  Route _createRoute(
    BuildContext context,
    RouteSettings settings,
    MicroAppRoute microAppRoute,
  ) {
    final transitionType = microAppRoute.transitionType;

    if (transitionType == TransitionType.defaultTransition) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoRoute(
          settings: settings,
          maintainState: microAppRoute.maintainState,
          isOpaque: microAppRoute.opaque,
          builder: (ctx) => microAppRoute.child(ctx, settings.arguments),
        );
      }

      return PageRouteBuilder(
        settings: settings,
        maintainState: microAppRoute.maintainState,
        opaque: microAppRoute.opaque,
        pageBuilder:
            (ctx, __, ___) => microAppRoute.child(ctx, settings.arguments),
      );
    } else if (transitionType == TransitionType.noTransition) {
      return NoTransitionPageRoute(
        settings: settings,
        maintainState: microAppRoute.maintainState,
        isOpaque: microAppRoute.opaque,
        builder: (ctx) => microAppRoute.child(ctx, settings.arguments),
      );
    } else {
      var selectTransition = microAppRoute.transitions[transitionType]!;

      return selectTransition(
        microAppRoute.child(context, settings.arguments),
        const Duration(milliseconds: 300),
        settings,
        microAppRoute.maintainState,
        microAppRoute.opaque,
      );
    }
  }
}
