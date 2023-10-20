import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/core/capture_http_overrides.dart';
import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/generated/assets/network_capture_assets.dart';
import 'package:network_capture/view/network_list_widget.dart';

/// createTime: 2023/10/20 on 17:37
/// desc:
///
/// @author azhon
class NetWorkCaptureInit extends StatefulWidget {
  final Widget child;
  final Size designSize;

  const NetWorkCaptureInit({
    required this.child,
    this.designSize = const Size(375, 667),
    super.key,
  });

  @override
  State createState() => _NetWorkCaptureState();
}

class _NetWorkCaptureState extends State<NetWorkCaptureInit> {
  ///当前位置
  Offset _offset = Offset.zero;

  ///按钮大小
  Size get iconSize => Size.square(48.cw);

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = CaptureHttpOverrides();
    AppDb.instance.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = MediaQuery.of(context);
    CaptureScreenAdapter.instance.init(widget.designSize, data);
    final size = CaptureScreenAdapter.instance.screen;
    _offset = Offset(size.width - iconSize.width - 20.cw, size.height - 240.cw);
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (c) {
            return widget.child;
          },
        ),
        OverlayEntry(
          builder: (c) {
            return Positioned(
              left: _offset.dx,
              top: _offset.dy,
              child: Draggable(
                childWhenDragging: const SizedBox.shrink(),
                onDragEnd: _dragUpdate,
                feedback: _floatingWidget(),
                child: _floatingWidget(),
              ),
            );
          },
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
    return GestureDetector(
      onTap: () => NetworkListWidget.showDialog(context),
      child: Card(
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 2.cw,
        child: Image.asset(
          NetworkCaptureAssets.icEntrance,
          width: iconSize.width,
          height: iconSize.height,
        ),
      ),
    );
  }
}
