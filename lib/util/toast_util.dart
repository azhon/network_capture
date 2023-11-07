import 'package:flutter/material.dart';

/// createTime: 2023/11/7 on 14:42
/// desc:
///
/// @author azhon
class ToastUtil {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(msg),
      ),
    );
  }
}
