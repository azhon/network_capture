import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_capture/view/network_capture_button.dart';

/// createTime: 2023/10/23 on 17:41
/// desc:
///
/// @author azhon
late NavigatorState ncNavigator;

class NetworkCaptureApp extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const NetworkCaptureApp({
    required this.child,
    required this.navigatorKey,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkCaptureAppState();
}

class _NetworkCaptureAppState extends State<NetworkCaptureApp> {
  final GlobalKey<OverlayState> _overlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _findNavigator();
      _overlayKey.currentState?.insert(
        OverlayEntry(builder: (_) => const NetWorkCaptureButton()),
      );
    });
  }

  void _findNavigator() {
    if (widget.navigatorKey.currentContext == null) {
      throw Exception('navigatorKey must not be null!');
    }
    ncNavigator = Navigator.of(widget.navigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          delegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          locale: const Locale('en', 'US'),
          child: Overlay(
            key: _overlayKey,
            initialEntries: [
              OverlayEntry(builder: (_) => widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
