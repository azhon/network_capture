import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:network_capture/view/widget/flutter_highlight_selectable.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

/// createTime: 2023/10/23 on 15:56
/// desc:
///
/// @author azhon
class JsonTextWidget extends StatelessWidget {
  final String? text;
  final double leftPadding;
  final double fontSize;

  const JsonTextWidget({
    required this.text,
    this.leftPadding = 0,
    this.fontSize = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RemoveRippleWidget(
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HighlightViewSelectable(
                const JsonEncoder.withIndent('  ')
                    .convert(jsonDecode(text ?? '')),
                padding: EdgeInsets.only(left: leftPadding),
                language: 'json',
                theme: _codeTheme(),
                textStyle: TextStyle(fontSize: fontSize),
              ),
            ],
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
