import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/util/hex_util.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

/// createTime: 2023/10/23 on 15:56
/// desc:
///
/// @author azhon
class HexWidget extends StatelessWidget {
  final String? text;

  const HexWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final list = _calcHex();
    return Padding(
      padding: EdgeInsets.only(left: 4.cw, right: 4.cw),
      child: RemoveRippleWidget(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.map((e) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 2.cw),
                  child: Row(
                    children: [
                      Text(
                        e.num,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.csp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(width: 16.cw),
                      Text(
                        e.hex,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.csp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(width: 16.cw),
                      Text(
                        e.str
                            .replaceAll('\n', '')
                            .replaceAll('\t', '  ')
                            .replaceAll('�', ' '),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.csp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<HexResult> _calcHex() {
    final List<HexResult> result = [];
    const int length = 16;
    final list = utf8.encode(text ?? '');
    final line = (list.length / length).ceil();

    for (int i = 0; i < line; i++) {
      final start = i * length;
      final end = start + length;
      final str = list.sublist(start, end > list.length ? list.length : end);
      result.add(
        HexResult(
          start.toRadixString(16).padLeft(8, '0'),
          HexUtil.encode(str),
          utf8.decode(str, allowMalformed: true),
        ),
      );
    }
    return result;
  }
}

class HexResult {
  final String num;
  final String hex;
  final String str;

  HexResult(this.num, this.hex, this.str);
}
