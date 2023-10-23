import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';

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
    final Map params = jsonDecode(queryString ?? '');
    int line = 0;
    return LayoutBuilder(
      builder: (context, constrain) {
        return Table(
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
                    (e) => _tableRow(e, params[e], ++line),
                  )
                  .toList(),
        );
      },
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

  TableRow _tableRow(String key, String value, int line) {
    return TableRow(
      decoration: BoxDecoration(
        color: line.isEven ? const Color(0xFFF5F5F5) : Colors.white60,
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            key,
            style: TextStyle(
              fontSize: 12.csp,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.csp,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}
