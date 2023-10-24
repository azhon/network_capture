import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/http/response/http_client_response_adapter.dart';

/// createTime: 2023/10/20 on 14:57
/// desc:
///
/// @author azhon
class CaptureHttpResponse extends HttpClientResponseAdapter {
  late NetworkHistoryTable table;
  final List<int> _data = [];

  CaptureHttpResponse(this.table, super.origin);

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    table.responseHeaders = table.transformHeaders(headers);
    if (!_canResolve()) {
      ///不受支持的解析类型
      return origin.transform(streamTransformer);
    }
    streamTransformer = StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data as S);
        _data.addAll(data);
      },
      handleDone: (sink) {
        sink.close();
        _decodeResponse(_data);
        _data.clear();
      },
    );
    return origin.transform(streamTransformer);
  }

  ///是否是可以解析的响应数据
  bool _canResolve() {
    final contentType = headers.contentType?.toString();
    if (contentType == null) {
      return false;
    }
    if (contentType.contains('json') ||
        contentType.contains('text') ||
        contentType.contains('xml')) {
      return true;
    }
    return false;
  }

  ///解析返回的数据
  void _decodeResponse(List<int> data) {
    table.contentLength = contentLength;
    table.statusCode = statusCode;
    table.reasonPhrase = reasonPhrase;
    table.response = _getEncoding()?.decode(data);
    table.endTime = DateTime.now().millisecondsSinceEpoch;
    AppDb.instance.insert(NetworkHistoryTable.tableName, table.toMap());
  }

  ///根据响应头获取编码格式
  Encoding? _getEncoding() {
    final String? charset = headers.contentType?.charset;
    return Encoding.getByName(charset ?? ContentType.text.charset);
  }
}
