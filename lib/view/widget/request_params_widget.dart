/// createTime: 2023/10/23 on 09:36
/// desc:
///
/// @author azhon
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/util/constant.dart';
import 'package:network_capture/view/tab/multipart_widget.dart';
import 'package:network_capture/view/tab/query_string_widget.dart';

class RequestParamsWidget extends StatefulWidget {
  final NetworkHistoryTable table;

  const RequestParamsWidget({
    required this.table,
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
                  child: _buildParamsWidget(con.maxWidth),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParamsWidget(double maxWidth) {
    if (widget.table.method == Constant.get) {
      return QueryStringWidget(
        queryString: widget.table.params,
        leftPadding: 4.cw,
      );
    }
    final String contentType =
        widget.table.requestHeaders?[HttpHeaders.contentTypeHeader] ?? '';
    if (contentType.contains(Constant.jsonH)) {
      return Row(
        children: [
          SizedBox(
            width: maxWidth,
            child: HighlightView(
              const JsonEncoder.withIndent('  ')
                  .convert(jsonDecode(widget.table.params ?? '')),
              padding: EdgeInsets.only(left: 2.cw),
              language: 'json',
              theme: _codeTheme(),
              textStyle: TextStyle(fontSize: 10.cw),
            ),
          ),
        ],
      );
    }
    if (contentType.contains(Constant.multipartH)) {
      return MultipartWidget(
        multipart: widget.table.params,
        leftPadding: 4.cw,
      );
    }
    return const SizedBox.shrink();
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
