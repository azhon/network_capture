/// createTime: 2023/10/20 on 21:05
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';

class NetworkListWidget extends StatefulWidget {
  const NetworkListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _NetworkListWidgetState();

  static Future showDialog(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.cw),
          topRight: Radius.circular(16.cw),
        ),
      ),
      builder: (_) {
        final height = MediaQuery.of(context).size.height * 0.85;
        return SizedBox(
          height: height,
          child: const NetworkListWidget(),
        );
      },
    );
  }
}

class _NetworkListWidgetState extends State<NetworkListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
