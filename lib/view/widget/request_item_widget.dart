import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:intl/intl.dart';
import 'package:network_capture/util/dialog_util.dart';
import 'package:network_capture/util/format_util.dart';
import 'package:network_capture/view/network_info_widget.dart';
import 'package:network_capture/view/widget/request_params_widget.dart';

/// createTime: 2023/10/20 on 22:07
/// desc:
///
/// @author azhon
class RequestItemWidget extends StatefulWidget {
  final NetworkHistoryTable table;

  const RequestItemWidget({required this.table, super.key});

  @override
  State<StatefulWidget> createState() => _RequestItemWidgetState();
}

class _RequestItemWidgetState extends State<RequestItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NetworkInfoWidget(table: widget.table),
          ),
        );
      },
      child: Card(
        shadowColor: Colors.black,
        elevation: 2.cw,
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 12.cw),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.cw, vertical: 6.cw),
          child: Column(
            children: [
              _rowWidget('Uri', widget.table.path, import: true),
              _rowWidget('Host', widget.table.origin),
              _rowWidget('Time', _getDate()),
              Row(
                children: [
                  _label('${widget.table.method}', false),
                  _label('${widget.table.statusCode}', true),
                  Padding(
                    padding: EdgeInsets.only(right: 4.cw),
                    child: Text(
                      'Cost:${widget.table.cost}ms',
                      style: TextStyle(
                        fontSize: 10.csp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 4.cw),
                    child: Text(
                      'Size:${FormatUtil.formatSize(widget.table.contentLength)}',
                      style: TextStyle(
                        fontSize: 10.csp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.cw),
              RequestParamsWidget(table: widget.table),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowWidget(
    String title,
    String value, {
    bool import = false,
  }) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: 12.csp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onDoubleTap: () => DialogUtil.showCopyDialog(context, value),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.csp,
                  color: import
                      ? const Color(0xFF333333)
                      : const Color(0xFF666666),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text, bool statusCode) {
    bool isError = false;
    if (statusCode) {
      isError = text != HttpStatus.ok.toString();
    }
    return Container(
      margin: EdgeInsets.only(right: 4.cw),
      padding: EdgeInsets.symmetric(horizontal: 2.cw),
      decoration: BoxDecoration(
        color: isError ? Colors.red : const Color(0XFFFF9900),
        borderRadius: BorderRadius.circular(4.cw),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 8.csp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  ///解析时间
  String _getDate() {
    final date = widget.table.startTime;
    if (date == null) {
      return '';
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(date));
  }
}
