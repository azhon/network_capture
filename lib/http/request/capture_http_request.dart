import 'dart:convert';
import 'dart:io';

import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/http/request/http_client_request_adapter.dart';
import 'package:network_capture/http/response/capture_http_response.dart';

/// createTime: 2023/10/20 on 14:20
/// desc:
///
/// @author azhon
class CaptureHttpRequest extends HttpClientRequestAdapter {
  late NetworkHistoryTable table;
  final List<int> _data = [];

  CaptureHttpRequest(super.origin) {
    table = NetworkHistoryTable(
      method: origin.method,
      url: origin.uri.toString(),
      params: jsonEncode(origin.uri.queryParameters),
      startTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<HttpClientResponse> close() {
    ///在这里才能拿到所有的headers
    table.requestHeaders = table.transformHeaders(origin.headers);
    return _proxy(origin.close());
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    _data.clear();
    stream = stream.asBroadcastStream();
    stream.listen((List<int> event) {
      _data.addAll(event);
      table.params = encoding.decode(_data);
    });
    return origin.addStream(stream);
  }

  Future<HttpClientResponse> _proxy(Future<HttpClientResponse> future) async {
    return CaptureHttpResponse(table, await future);
  }
}
