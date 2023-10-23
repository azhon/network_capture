/// createTime: 2023/10/23 on 09:36
/// desc:
///
/// @author azhon
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';

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
        child: LayoutBuilder(
          builder: (context, constrain) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Params',
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
                Visibility(
                  visible: expand,
                  child: isGet
                      ? _getParams(constrain.maxWidth)
                      : Row(
                          children: [
                            HighlightView(
                              const JsonEncoder.withIndent('  ')
                                  .convert(jsonDecode(widget.params ?? '')),
                              padding: EdgeInsets.only(left: 2.cw),
                              language: 'json',
                              theme: _codeTheme(),
                              textStyle: TextStyle(fontSize: 10.cw),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool get isGet => widget.method == 'GET';

  Widget _getParams(double width) {
    final Map params = jsonDecode(widget.params ?? '');
    int line = 0;
    return Row(
      children: [
        Table(
          columnWidths: {
            0: MaxColumnWidth(
              FixedColumnWidth(width * 0.3),
              const FractionColumnWidth(0.1),
            ),
            1: MaxColumnWidth(
              FixedColumnWidth(width * 0.7),
              const FractionColumnWidth(0.1),
            ),
          },
          children: [
                _tableHeader(),
              ] +
              params.keys
                  .map(
                    (e) => _tableRow(e, params[e], ++line),
                  )
                  .toList(),
        ),
      ],
    );
  }

  TableRow _tableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      children: [
        Text(
          ' key',
          style: TextStyle(
            fontSize: 12.csp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        Text(
          ' value',
          style: TextStyle(
            fontSize: 12.csp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  TableRow _tableRow(String key, String value, int line) {
    return TableRow(
      decoration: BoxDecoration(
        color: line.isEven ? const Color(0xFFF5F5F5) : Colors.white60,
      ),
      children: [
        Text(
          ' $key',
          style: TextStyle(
            fontSize: 12.csp,
            color: const Color(0xFF666666),
          ),
        ),
        Text(
          ' $value',
          style: TextStyle(
            fontSize: 12.csp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
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
