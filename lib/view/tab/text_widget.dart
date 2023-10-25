import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

/// createTime: 2023/10/23 on 15:56
/// desc:
///
/// @author azhon
class TextWidget extends StatelessWidget {
  final String? text;

  const TextWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.cw),
      child: RemoveRippleWidget(
        child: SingleChildScrollView(
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: 12.csp,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}
