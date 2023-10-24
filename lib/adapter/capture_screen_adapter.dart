import 'package:flutter/cupertino.dart';

/// createTime: 2023/10/20 on 17:46
/// desc:
///
/// @author azhon
class CaptureScreenAdapter {
  factory CaptureScreenAdapter() => _getInstance();

  static CaptureScreenAdapter get instance => _getInstance();
  static CaptureScreenAdapter? _instance;

  static CaptureScreenAdapter _getInstance() {
    _instance ??= CaptureScreenAdapter._internal();
    return _instance!;
  }

  CaptureScreenAdapter._internal();

  final Size designSize = const Size(375, 667);

  double scaleWidth = 0;
  Size screen = Size.zero;

  void init(MediaQueryData data) {
    screen = data.size;
    scaleWidth = screen.width / designSize.width;
  }
}

extension NumExt on num {
  double get cw => this * CaptureScreenAdapter.instance.scaleWidth;

  double get csp => cw;
}
