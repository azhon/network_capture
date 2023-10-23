/// createTime: 2023/10/23 on 09:36
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/view/tab/json_text_widget.dart';
import 'package:network_capture/view/tab/query_string_widget.dart';

class RequestParamsWidget extends StatefulWidget {
  final String? method;
  final String? params;

  const RequestParamsWidget({
    this.method,
    this.params,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RequestParamsWidgetState();
}

class _RequestParamsWidgetState extends State<RequestParamsWidget> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expand = !expand;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(4.cw),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Params',
                  style: TextStyle(
                    fontSize: 12.csp,
                    color: const Color(0xFF333333),
                  ),
                ),
                Icon(
                  expand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 24.cw,
                ),
              ],
            ),
            Visibility(
              visible: expand,
              child: isGet
                  ? QueryStringWidget(
                      queryString: widget.params,
                      leftPadding: 4.cw,
                    )
                  : JsonTextWidget(
                      text: widget.params,
                      leftPadding: 2.cw,
                      fontSize: 10.cw,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isGet => widget.method == 'GET';
}
