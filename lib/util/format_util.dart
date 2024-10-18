import 'dart:math';

import 'package:intl/intl.dart';

/// createTime: 2023/10/21 on 10:53
/// desc:
///
/// @author azhon
class FormatUtil {
  ///格式化字节大小
  static String formatSize(int? size) {
    final units = ['B', 'KB', 'MB', 'GB', 'TB'];
    if (size == null || size <= 0) {
      return '0KB';
    }
    int index = 0;
    double value = size.toDouble();
    while (value >= 1024) {
      value = value / 1024;
      index++;
    }
    return '${NumberFormat("#,##0.#").format(value)}${units[index]}';
  }
}
