import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_capture/view/network_capture_button.dart';

/// createTime: 2023/10/23 on 17:41
/// desc:
///
/// @author azhon
bool ncEnable = false;

class NetworkCaptureApp extends StatefulWidget {
  final bool enable;
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  NetworkCaptureApp({
    required this.child,
    required this.navigatorKey,
    this.enable = false,
    super.key,
  }) {
    ncEnable = enable;
  }

  @override
  State<StatefulWidget> createState() => _NetworkCaptureAppState();
}

class _NetworkCaptureAppState extends State<NetworkCaptureApp> {
  final GlobalKey<OverlayState> _overlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!widget.enable) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _overlayKey.currentState?.insert(
        OverlayEntry(builder: (_) => NetWorkCaptureButton(widget.navigatorKey)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) {
      return widget.child;
    }
    return Material(
      child: Theme(
        data: ThemeData(useMaterial3: false),
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
      ),
    );
  }
}
