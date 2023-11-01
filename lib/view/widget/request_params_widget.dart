/// createTime: 2023/10/23 on 09:36
/// desc:
///
/// @author azhon
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:network_capture/util/constant.dart';
import 'package:network_capture/view/tab/query_string_widget.dart';

class RequestParamsWidget extends StatefulWidget {
  final String? method;
  final String? params;

  const RequestParamsWidget({
    this.method,
    this.params,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RequestParamsWidgetState();
}

class _RequestParamsWidgetState extends State<RequestParamsWidget> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expand = !expand;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(4.cw),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Params',
                  style: TextStyle(
                    fontSize: 12.csp,
                    color: const Color(0xFF333333),
                  ),
                ),
                Icon(
                  expand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 24.cw,
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, con) {
                return Visibility(
                  visible: expand,
                  child: isGet
                      ? QueryStringWidget(
                          queryString: widget.params,
                          leftPadding: 4.cw,
                        )
                      : Row(
                          children: [
                            SizedBox(
                              width: con.maxWidth,
                              child: HighlightView(
                                const JsonEncoder.withIndent('  ')
                                    .convert(jsonDecode(widget.params ?? '')),
                                padding: EdgeInsets.only(left: 2.cw),
                                language: 'json',
                                theme: _codeTheme(),
                                textStyle: TextStyle(fontSize: 10.cw),
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool get isGet => widget.method == Constant.get;

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
