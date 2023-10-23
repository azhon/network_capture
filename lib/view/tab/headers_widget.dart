import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';

/// createTime: 2023/10/23 on 14:53
/// desc:
///
/// @author azhon
class HeadersWidget extends StatelessWidget {
  final Map<String, dynamic>? topHeaders;
  final Map<String, dynamic>? headers;

  const HeadersWidget({
    required this.headers,
    this.topHeaders,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _children(topHeaders) + _children(headers),
    );
  }

  List<Widget> _children(Map<String, dynamic>? headers) {
    return headers?.keys
            .map(
              (e) => _rowWidget(e, headers[e]),
            )
            .toList() ??
        [];
  }

  Widget _rowWidget(String key, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8.cw),
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 12.csp,
                  color: const Color(0xFF666666),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.csp,
                color: const Color(0xFF333333),
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
