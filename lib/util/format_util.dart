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
    final int digitGroups = (log(size) / log(size)).round();
    return '${NumberFormat("#,##0.#").format(size / pow(1024, digitGroups))} '
        '${units[digitGroups]}';
  }
}
