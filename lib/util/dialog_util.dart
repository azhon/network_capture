import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/network_capture.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

/// createTime: 2023/11/7 on 14:08
/// desc:
///
/// @author azhon
class DialogUtil {
  ///显示对话框
  static Future<bool?> showCopyDialog(BuildContext context, String? message) {
    if (message == null || message.isEmpty) {
      return Future.value(false);
    }
    return showDialog<bool?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          elevation: 0,
          title: const Center(child: Text('Content')),
          titleTextStyle: TextStyle(
            fontSize: 16.csp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
          titlePadding: EdgeInsets.only(top: 10.cw),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.cw,
            vertical: 10.cw,
          ),
          content: RemoveRippleWidget(
            child: SingleChildScrollView(
              child: Text(
                message ?? '',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 14.csp,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ncNavigator.pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 14.csp,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message ?? ''));
                ncNavigator.pop();
              },
              child: Text(
                'Copy',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 14.csp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
