import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/view/widget/flutter_highlight_selectable.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

/// createTime: 2023/10/23 on 15:56
/// desc:
///
/// @author azhon
class JsonTextWidget extends StatelessWidget {
  final String? text;
  final bool safeBottom;

  const JsonTextWidget({
    required this.text,
    this.safeBottom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RemoveRippleWidget(
      child: Scrollbar(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: safeBottom ? MediaQuery.of(context).padding.bottom : 0,
          ),
          child: HighlightViewSelectable(
            const JsonEncoder.withIndent('  ').convert(jsonDecode(text ?? '')),
            padding: EdgeInsets.only(left: 4.cw),
            language: 'json',
            theme: _codeTheme(),
            textStyle: TextStyle(fontSize: 12.csp),
            wantKeepAlive: true,
          ),
        ),
      ),
    );
  }

  ///代码主题
  Map<String, TextStyle> _codeTheme() {
    final map = <String, TextStyle>{}..addAll(themeMap['googlecode'] ?? {});
    map['root'] = const TextStyle(
      backgroundColor: Colors.transparent,
      color: Color(0XFF000000),
    );
    return map;
  }
}
