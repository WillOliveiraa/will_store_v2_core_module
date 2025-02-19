import 'package:flutter/widgets.dart';

import './screen_util.dart';

export './screen_util.dart';

typedef RebuildFactor = bool Function(MediaQueryData old, MediaQueryData data);

typedef ScreenInitBuilder = Widget Function(BuildContext context);

class RebuildFactors {
  const RebuildFactors._();

  static bool size(MediaQueryData old, MediaQueryData data) {
    return old.size != data.size;
  }

  static bool orientation(MediaQueryData old, MediaQueryData data) {
    return old.orientation != data.orientation;
  }

  static bool sizeAndViewInsets(MediaQueryData old, MediaQueryData data) {
    return old.viewInsets != data.viewInsets;
  }

  static bool all(MediaQueryData old, MediaQueryData data) {
    return old != data;
  }
}

class ScreenConfig extends StatefulWidget {
  /// A helper widget that initializes [ScreenUtil]
  const ScreenConfig({
    super.key,
    required this.builder,
    this.child,
    this.rebuildFactor = RebuildFactors.size,
    this.designSize = ScreenUtil.defaultSize,
    this.minTextAdapt = false,
    this.useInheritedMediaQuery = false,
    this.ignoreDynamicSize = false,
  });

  final bool ignoreDynamicSize;
  final ScreenInitBuilder builder;
  final Widget? child;
  final bool minTextAdapt;
  final bool useInheritedMediaQuery;
  final RebuildFactor rebuildFactor;

  /// The [Size] of the device in the design draft, in dp
  final Size designSize;

  @override
  State<ScreenConfig> createState() => _ScreenConfigState();
}

class _ScreenConfigState extends State<ScreenConfig>
    with WidgetsBindingObserver {
  late MediaQueryData mediaQueryData;

  bool wrappedInMediaQuery = false;

  WidgetsBinding get binding => WidgetsFlutterBinding.ensureInitialized();

  MediaQueryData get newData {
    if (widget.useInheritedMediaQuery) {
      final element =
          context.getElementForInheritedWidgetOfExactType<MediaQuery>();
      final mediaQuery = element?.widget as MediaQuery?;
      final data = mediaQuery?.data;

      if (data != null) {
        wrappedInMediaQuery = true;
        return data;
      }
    }

    // ignore: deprecated_member_use
    return MediaQueryData.fromWindow(binding.window);
  }

  Widget get child {
    return widget.builder.call(context);
  }

  _updateTree(Element el) {
    el.markNeedsBuild();
    el.visitChildren(_updateTree);
  }

  @override
  void initState() {
    super.initState();
    mediaQueryData = newData;
    binding.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final old = mediaQueryData;
    final data = newData;

    if (widget.rebuildFactor(old, data)) {
      mediaQueryData = data;
      _updateTree(context as Element);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangeMetrics();
  }

  @override
  void dispose() {
    binding.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    if (mediaQueryData.size == Size.zero) return const SizedBox();
    if (!wrappedInMediaQuery) {
      return MediaQuery(
        data: mediaQueryData,
        child: Builder(
          builder: (context) {
            final deviceData = MediaQuery.maybeOf(context);
            final deviceSize = deviceData?.size ?? widget.designSize;

            ScreenUtil.init(
              context,
              designSize: widget.designSize,
              minTextAdapt: widget.minTextAdapt,
              ignoreDynamicSize: widget.ignoreDynamicSize,
            );

            return SizedBox(
              width: deviceSize.width,
              height: deviceSize.height,
              child: FittedBox(
                fit: BoxFit.none,
                alignment: Alignment.center,
                child: SizedBox(
                  width: deviceSize.width,
                  height: deviceSize.height,
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    }

    final deviceData = MediaQuery.maybeOf(context);
    final deviceSize = deviceData?.size ?? widget.designSize;

    ScreenUtil.init(
      ctx,
      designSize: widget.designSize,
      minTextAdapt: widget.minTextAdapt,
      ignoreDynamicSize: widget.ignoreDynamicSize,
    );

    return SizedBox(
      width: deviceSize.width,
      height: deviceSize.height,
      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment.center,
        child: SizedBox(
          width: deviceSize.width,
          height: deviceSize.height,
          child: child,
        ),
      ),
    );
  }
}
