import 'package:flutter/material.dart';

enum PageTransitionType {
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

class PageTransition<T> extends PageRouteBuilder<T> {
  final Widget Function(BuildContext context) builder;
  final PageTransitionType type;
  final Curve curve;
  final Alignment alignment;
  final Duration duration;

  PageTransition({
    Key? key,
    required this.builder,
    required this.type,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 600),
    super.settings,
    super.maintainState,
    super.opaque,
  }) : super(
         pageBuilder: (context, _, ___) => builder(context),
         transitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _transitionsBuilder(
             context,
             animation,
             secondaryAnimation,
             child,
             type,
             curve,
             alignment,
           );
         },
       );

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PageTransitionType type,
    Curve curve,
    Alignment alignment,
  ) {
    switch (type) {
      case PageTransitionType.rightToLeft:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1.0, 0.0),
            ).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: curve),
            ),
            child: child,
          ),
        );

      case PageTransitionType.leftToRight:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(1.0, 0.0),
            ).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: curve),
            ),
            child: child,
          ),
        );

      case PageTransitionType.upToDown:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, 1.0),
            ).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: curve),
            ),
            child: child,
          ),
        );

      case PageTransitionType.downToUp:
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -1.0),
            ).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: curve),
            ),
            child: child,
          ),
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          alignment: alignment,
          scale: CurvedAnimation(
            parent: animation,
            curve: Interval(0, .50, curve: curve),
          ),
          child: child,
        );

      case PageTransitionType.rotate:
        return RotationTransition(
          alignment: alignment,
          turns: CurvedAnimation(parent: animation, curve: curve),
          child: ScaleTransition(
            alignment: Alignment.center,
            scale: CurvedAnimation(parent: animation, curve: curve),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );

      case PageTransitionType.size:
        return Align(
          alignment: Alignment.center,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );

      case PageTransitionType.rightToLeftWithFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: curve),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-1.0, 0.0),
              ).animate(
                CurvedAnimation(parent: secondaryAnimation, curve: curve),
              ),
              child: child,
            ),
          ),
        );

      case PageTransitionType.leftToRightWithFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: curve),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1.0, 0.0),
              ).animate(
                CurvedAnimation(parent: secondaryAnimation, curve: curve),
              ),
              child: child,
            ),
          ),
        );

      default:
        return child;
    }
  }
}

class NoTransitionPageRoute<T> extends MaterialPageRoute<T> {
  final bool isOpaque;

  NoTransitionPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    this.isOpaque = true,
  });

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  bool get opaque => isOpaque;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
