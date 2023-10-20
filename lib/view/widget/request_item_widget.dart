/// createTime: 2023/10/20 on 22:07
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:intl/intl.dart';

class RequestItemWidget extends StatefulWidget {
  final NetworkHistoryTable table;

  const RequestItemWidget({required this.table, super.key});

  @override
  State<StatefulWidget> createState() => _RequestItemWidgetState();
}

class _RequestItemWidgetState extends State<RequestItemWidget> {
  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(widget.table.url ?? '');
    return Card(
      shadowColor: Colors.black,
      elevation: 2.cw,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 12.cw),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.cw, vertical: 6.cw),
        child: Column(
          children: [
            _rowWidget('Method', widget.table.method ?? '', border: true),
            _rowWidget('Host', _getHost(uri)),
            _rowWidget('Path', uri.path),
            _rowWidget('Time', _getDate()),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget(
    String title,
    String value, {
    bool border = false,
  }) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: 14.csp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        Container(
          padding: border ? EdgeInsets.symmetric(horizontal: 4.cw) : null,
          decoration: border
              ? BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(4.cw),
                )
              : null,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.csp,
              color: border ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }

  ///解析主机
  String _getHost(Uri uri) {
    String port = '';
    if (uri.port != 80) {
      port = ':${uri.port}';
    }
    return '${uri.scheme}://${uri.host}$port';
  }

  ///解析时间
  String _getDate() {
    final String date = widget.table.responseHeaders?['date'] ?? '';
    final datetime = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(date);
    final time = datetime.add(datetime.timeZoneOffset).toString();
    return time.substring(0, time.lastIndexOf('.'));
  }
}
