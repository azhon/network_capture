import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/http/capture_http_overrides.dart';
import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/generated/assets/network_capture_assets.dart';
import 'package:network_capture/view/network_list_widget.dart';

/// createTime: 2023/10/20 on 17:37
/// desc:
///
/// @author azhon
class NetWorkCaptureButton extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const NetWorkCaptureButton(this.navigatorKey, {super.key});

  @override
  State createState() => _NetWorkCaptureButtonState();
}

class _NetWorkCaptureButtonState extends State<NetWorkCaptureButton>
    with TickerProviderStateMixin {
  ///当前位置
  Offset _offset = Offset.zero;

  ///按钮大小
  Size get iconSize => Size.square(56.cw);
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = CaptureHttpOverrides();
    AppDb.instance.init();
    _createAnimation();
  }

  ///查找[Navigator]
  NavigatorState _findNavigator() {
    if (widget.navigatorKey.currentContext == null) {
      throw Exception('navigatorKey must not be null!');
    }
    return Navigator.of(widget.navigatorKey.currentContext!);
  }

  void _createAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = MediaQuery.of(context);
    CaptureScreenAdapter.instance.init(data);
    final size = CaptureScreenAdapter.instance.screen;
    _offset = Offset(size.width - iconSize.width - 20.cw, size.height - 240.cw);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Draggable(
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: _dragUpdate,
            feedback: _floatingWidget(),
            child: _floatingWidget(),
          ),
        ),
      ],
    );
  }

  void _dragUpdate(DraggableDetails detail) {
    final size = CaptureScreenAdapter.instance.screen;
    double x = detail.offset.dx;
    double y = detail.offset.dy;
    if (x <= 0) {
      x = 0;
    }
    if (x >= size.width - iconSize.width) {
      x = size.width - iconSize.width;
    }
    if (y <= 0) {
      y = 0;
    }
    if (y >= size.height - iconSize.height) {
      y = size.height - iconSize.height;
    }

    setState(() {
      _offset = Offset(x, y);
    });
  }

  ///抓包结果入口
  Widget _floatingWidget() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            elevation: 3.cw,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(iconSize.width),
              child: Image.asset(
                NetworkCaptureAssets.icEntrance,
                width: iconSize.width,
                height: iconSize.height,
              ),
            ),
            onPressed: () async {
              // ignore: unawaited_futures
              _animationController.forward();
              await NetworkListWidget.showDialog(_findNavigator());
              await _animationController.reverse();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
