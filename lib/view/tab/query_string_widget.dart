import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/util/dialog_util.dart';

/// createTime: 2023/10/23 on 14:53
/// desc:
///
/// @author azhon
class QueryStringWidget extends StatelessWidget {
  final String? queryString;
  final double leftPadding;

  const QueryStringWidget({
    required this.queryString,
    this.leftPadding = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map params = {};
    if (queryString != null && queryString!.isNotEmpty) {
      params = jsonDecode(queryString!);
    }
    int line = 0;
    return SelectionArea(
      child: LayoutBuilder(
        builder: (context, constrain) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Table(
              columnWidths: {
                0: MaxColumnWidth(
                  FixedColumnWidth(constrain.maxWidth * 0.3),
                  const FractionColumnWidth(0.1),
                ),
                1: MaxColumnWidth(
                  FixedColumnWidth(constrain.maxWidth * 0.7),
                  const FractionColumnWidth(0.1),
                ),
              },
              children: [
                    _tableHeader(),
                  ] +
                  params.keys
                      .map(
                        (e) => _tableRow(context, e, params[e], ++line),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }

  TableRow _tableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            'key',
            style: TextStyle(
              fontSize: 12.csp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            'value',
            style: TextStyle(
              fontSize: 12.csp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _tableRow(
    BuildContext context,
    String key,
    String? value,
    int line,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        color: line.isEven ? const Color(0xFFF5F5F5) : Colors.white60,
      ),
      children: [
        GestureDetector(
          onDoubleTap: () => DialogUtil.showCopyDialog(context, key),
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                key,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12.csp,
                  color: const Color(0xFF666666),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () => DialogUtil.showCopyDialog(context, value),
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                value ?? '',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12.csp,
                  color: const Color(0xFF666666),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
