import 'dart:async' show Completer;
import 'dart:math' show min, max;
// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/widgets.dart';

class ScreenUtil {
  static const Size defaultSize = Size(360, 690);
  static final ScreenUtil _instance = ScreenUtil._();

  /// Size of the phone in UI Design , dp
  late Size _uiSize;

  late double _screenWidth;
  late double _screenHeight;
  late bool _minTextAdapt;
  late bool _ignoreDynamicSize;

  Set<Element>? _elementsToRebuild;
  BuildContext? _context;

  ScreenUtil._();

  factory ScreenUtil() => _instance;

  static Future<void> ensureScreenSize([
    FlutterView? window,
    Duration duration = const Duration(milliseconds: 10),
  ]) async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    // ignore: deprecated_member_use
    window ??= binding.window;

    if (window.physicalSize.isEmpty) {
      return Future.delayed(duration, () async {
        binding.deferFirstFrame();
        await ensureScreenSize(window, duration);
        return binding.allowFirstFrame();
      });
    }
  }

  /// Initializing.
  static Future<void> init(
    BuildContext context, {
    Size designSize = defaultSize,
    bool minTextAdapt = false,
    bool ignoreDynamicSize = false,
  }) async {
    final navigatorContext = Navigator.maybeOf(context)?.context as Element?;
    final mediaQueryContext =
        navigatorContext?.getElementForInheritedWidgetOfExactType<MediaQuery>();

    final initCompleter = Completer<void>();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      mediaQueryContext?.visitChildElements((el) => _instance._context = el);
      if (_instance._context != null) initCompleter.complete();
    });

    final deviceData = MediaQuery.maybeOf(context).nonEmptySizeOrNull();

    final deviceSize = deviceData?.size ?? designSize;

    _instance
      .._context = context
      .._uiSize = designSize
      .._minTextAdapt = minTextAdapt
      .._screenWidth = deviceSize.width
      .._screenHeight = deviceSize.height
      .._ignoreDynamicSize = ignoreDynamicSize;

    _instance._elementsToRebuild?.forEach((el) => el.markNeedsBuild());

    return initCompleter.future;
  }

  /// The horizontal extent of this size.
  double get screenWidth =>
      _context != null ? MediaQuery.of(_context!).size.width : _screenWidth;

  /// The vertical extent of this size. dp
  double get screenHeight =>
      _context != null ? MediaQuery.of(_context!).size.height : _screenHeight;

  /// The ratio of actual width to UI design
  double get scaleWidth => screenWidth / _uiSize.width;

  /// The ratio of actual height to UI design
  double get scaleHeight => screenHeight / _uiSize.height;

  double get scaleText =>
      _minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth;

  /// Adapted to the device width of the UI Design.
  double setWidth(num width) =>
      _ignoreDynamicSize ? width.toDouble() : (width * scaleWidth);

  /// Highly adaptable to the device according to UI Design
  double setHeight(num height) =>
      _ignoreDynamicSize ? height.toDouble() : (height * scaleWidth);

  /// Adapt according to the smaller of width or height
  double radius(num r) =>
      _ignoreDynamicSize ? r.toDouble() : (r * max(scaleWidth, scaleHeight));

  /// The size of the font on the UI design, in dp.
  double setSp(num fontSize) =>
      _ignoreDynamicSize ? fontSize.toDouble() : (fontSize * scaleText);
}

extension on MediaQueryData? {
  MediaQueryData? nonEmptySizeOrNull() {
    if (this == null) return this;
    return this!.size.isEmpty ? null : this;
  }
}
