import 'dart:io';

import 'package:flutter/material.dart';

/// createTime: 2022/9/6 on 16:53
/// desc:
///
/// @author azhon
class RemoveRippleWidget extends StatelessWidget {
  final Widget child;

  const RemoveRippleWidget({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(behavior: _RemoveRippleBehavior(), child: child);
  }
}

class _RemoveRippleBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (Platform.isAndroid) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}
