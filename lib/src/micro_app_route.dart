import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';

import './micro_core_utils.dart';
import './navigator/transitions/transitions.dart';

typedef PageBuilderRoute = PageRouteBuilder<T> Function<T>(
  Widget widget,
  Duration transitionDuration,
  RouteSettings settings,
  bool maintainState,
  bool opaque,
);

enum TransitionType {
  defaultTransition,
  fadeIn,
  noTransition,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade
}

class MicroAppRoute {
  final String name;
  final WidgetBuilderArgs child;
  final TransitionType transitionType;
  final bool maintainState;
  final Duration? duration;
  final bool opaque;

  MicroAppRoute(
    this.name, {
    required this.child,
    this.transitionType = TransitionType.defaultTransition,
    this.maintainState = true,
    this.duration,
    this.opaque = true,
  });

  MicroAppRoute copyWith({
    String? name,
    WidgetBuilderArgs? child,
    TransitionType? transitionType,
    bool? maintainState,
    Duration? duration,
    bool? opaque,
  }) {
    return MicroAppRoute(
      name ?? this.name,
      child: child ?? this.child,
      transitionType: transitionType ?? this.transitionType,
      maintainState: maintainState ?? this.maintainState,
      duration: duration ?? this.duration,
      opaque: opaque ?? this.opaque,
    );
  }

  Map<TransitionType, PageBuilderRoute> get transitions => {
        TransitionType.fadeIn: fadeInTransition,
        TransitionType.rightToLeft: rightToLeft,
        TransitionType.leftToRight: leftToRight,
        TransitionType.upToDown: upToDown,
        TransitionType.downToUp: downToUp,
        TransitionType.scale: scale,
        TransitionType.rotate: rotate,
        TransitionType.size: size,
        TransitionType.rightToLeftWithFade: rightToLeftWithFade,
        TransitionType.leftToRightWithFade: leftToRightWithFade,
      };

  PageRouteBuilder<T> fadeInTransition<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageRouteBuilder<T>(
      opaque: opaque,
      settings: settings,
      transitionDuration: transitionDuration,
      maintainState: maintainState,
      pageBuilder: (context, __, ___) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  PageRouteBuilder<T> rightToLeft<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.rightToLeft,
    );
  }

  PageRouteBuilder<T> leftToRight<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.leftToRight,
    );
  }

  PageRouteBuilder<T> upToDown<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.upToDown,
    );
  }

  PageRouteBuilder<T> downToUp<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.downToUp,
    );
  }

  PageRouteBuilder<T> scale<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.scale,
    );
  }

  PageRouteBuilder<T> rotate<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.rotate,
    );
  }

  PageRouteBuilder<T> size<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.size,
    );
  }

  PageRouteBuilder<T> rightToLeftWithFade<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.rightToLeftWithFade,
    );
  }

  PageRouteBuilder<T> leftToRightWithFade<T>(
    Widget widget,
    Duration transitionDuration,
    RouteSettings settings,
    bool maintainState,
    bool opaque,
  ) {
    return PageTransition<T>(
      opaque: opaque,
      settings: settings,
      maintainState: maintainState,
      duration: transitionDuration,
      builder: (context) => widget,
      type: PageTransitionType.leftToRightWithFade,
    );
  }
}

class CupertinoRoute extends CupertinoPageRoute {
  final bool isOpaque;

  CupertinoRoute({
    required super.builder,
    super.fullscreenDialog,
    super.maintainState,
    super.settings,
    this.isOpaque = true,
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get opaque => isOpaque;
}
