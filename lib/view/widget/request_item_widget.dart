/// createTime: 2023/10/20 on 22:07
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:intl/intl.dart';
import 'package:network_capture/util/format_util.dart';

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
            SizedBox(height: 4.cw),
            Row(
              children: [
                _label('Method', widget.table.method ?? ''),
                _label('Status', '${widget.table.statusCode}'),
                _label('Cost', '${widget.table.cost}ms'),
                _label(
                  'Size',
                  FormatUtil.formatSize(widget.table.contentLength),
                ),
              ],
            ),
            SizedBox(height: 4.cw),
            _rowWidget('Time', _getDate()),
            _rowWidget('Url', uri.path),
            _rowWidget('Host', _getHost(uri)),
            _rowWidget('Params', widget.table.params ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _rowWidget(String title, String value) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: 13.csp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.csp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _label(String title, String value) {
    return Container(
      margin: EdgeInsets.only(right: 4.cw),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4.cw),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.cw),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10.csp,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.cw),
            decoration: BoxDecoration(
              color: const Color(0XFFFF9900),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4.cw),
                bottomRight: Radius.circular(4.cw),
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10.csp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///解析主机
  String _getHost(Uri uri) {
    String port = '';
    if (!(uri.port == 80 || uri.port == 443)) {
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
