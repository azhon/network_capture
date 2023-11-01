import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

/// createTime: 2023/10/23 on 15:56
/// desc:
///
/// @author azhon
class TextWidget extends StatelessWidget {
  final String? text;
  final bool safeBottom;

  const TextWidget({
    required this.text,
    this.safeBottom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.cw),
      child: RemoveRippleWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: safeBottom ? MediaQuery.of(context).padding.bottom : 0,
          ),
          physics: const ClampingScrollPhysics(),
          child: SelectableText(
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
