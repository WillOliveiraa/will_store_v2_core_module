import 'package:core_module/src/micro_app_route.dart';
import 'package:flutter/material.dart';

import './navigator/observers/base_route_observer.dart';
import './navigator/transitions/transitions.dart';

abstract class BaseRouter extends StatefulWidget {
  final String? initialRoute;

  const BaseRouter({super.key, this.initialRoute});

  List<MicroAppRoute> get privateRoutes;

  @override
  State<BaseRouter> createState() => _BaseRouterState();
}

class _BaseRouterState extends State<BaseRouter> {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  String? initialRoute;

  @override
  void initState() {
    super.initState();
    initialRoute = widget.initialRoute;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _canPopNavigate,
      child: Navigator(
        key: navKey,
        observers: [MicroAppRouteObserver()],
        initialRoute: widget.initialRoute,
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Future<bool> _canPopNavigate() async {
    final canPop = await navKey.currentState?.maybePop();
    return !(canPop ?? true);
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    try {
      var routerName = settings.name;

      final isInitialRoute = initialRoute != null && initialRoute == routerName;

      if (isInitialRoute) {
        var microAppWithInitialRoute = _searchMicroAppRoute(initialRoute);

        _clearInitialRoute();

        return _createRoute(context, settings, microAppWithInitialRoute);
      } else if (initialRoute == null) {
        var microAppWithoutInitialRoute = _searchMicroAppRoute(routerName);

        return _createRoute(context, settings, microAppWithoutInitialRoute);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void _clearInitialRoute() => initialRoute = null;

  MicroAppRoute _searchMicroAppRoute(String? routerName) {
    return widget.privateRoutes.firstWhere((route) => route.name == routerName);
  }

  Route _createRoute(
    BuildContext context,
    RouteSettings settings,
    MicroAppRoute microAppRoute,
  ) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final transitionType = microAppRoute.transitionType;

    if (transitionType == TransitionType.defaultTransition) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoRoute(
          settings: settings,
          maintainState: microAppRoute.maintainState,
          isOpaque: microAppRoute.opaque,
          builder:
              (ctx) => microAppRoute.child(ctx, settings.arguments ?? args),
        );
      }

      return PageRouteBuilder(
        settings: settings,
        maintainState: microAppRoute.maintainState,
        opaque: microAppRoute.opaque,
        pageBuilder:
            (ctx, __, ___) =>
                microAppRoute.child(ctx, settings.arguments ?? args),
      );
    } else if (transitionType == TransitionType.noTransition) {
      return NoTransitionPageRoute(
        settings: settings,
        maintainState: microAppRoute.maintainState,
        isOpaque: microAppRoute.opaque,
        builder: (ctx) => microAppRoute.child(ctx, settings.arguments ?? args),
      );
    } else {
      var selectTransition = microAppRoute.transitions[transitionType]!;

      return selectTransition(
        microAppRoute.child(context, settings.arguments ?? args),
        microAppRoute.duration ?? const Duration(milliseconds: 300),
        settings,
        microAppRoute.maintainState,
        microAppRoute.opaque,
      );
    }
  }
}
