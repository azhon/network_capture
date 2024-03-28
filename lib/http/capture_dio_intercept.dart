import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/network_capture.dart';

/// createTime: 2024/3/28 on 10:21
/// desc:
///
/// @author azhon
class CaptureDioInterceptor extends InterceptorsWrapper {
  final Map<int, DateTime> _recordMap = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ncEnable) {
      _recordMap[options.hashCode] = DateTime.now();
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (ncEnable) {
      _saveHttp(err.requestOptions, null, err);
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (ncEnable) {
      _saveHttp(response.requestOptions, response, null);
    }
    super.onResponse(response, handler);
  }

  void _saveHttp(
    RequestOptions request,
    Response? response,
    DioException? err,
  ) {
    final startTime = _recordMap.remove(request.hashCode);
    String? params;

    ///参数处理
    final uriParams = request.uri.queryParameters;
    if (uriParams.isEmpty) {
      if (request.data != null) {
        params = jsonEncode(request.data);
      }
    } else {
      params = jsonEncode(uriParams);
    }
    final table = NetworkHistoryTable(
      method: request.method,
      url: request.uri.toString(),
      params: params,
      startTime: startTime?.millisecondsSinceEpoch,
      requestHeaders: request.headers,
    );
    table.endTime = DateTime.now().millisecondsSinceEpoch;
    if (response == null) {
      table.reasonPhrase = err?.message;
    } else {
      if (response.data is Map) {
        table.response = jsonEncode(response.data);
      } else {
        table.response = response.data.toString();
      }
      table.responseHeaders = table.transformHeaders(response.headers);
      table.contentLength = _getContentLength(table.response);
      table.statusCode = response.statusCode;
      table.reasonPhrase = response.statusMessage;
    }

    ///保存
    AppDb.instance.insert(NetworkHistoryTable.tableName, table.toMap());
  }

  int _getContentLength(String? data) {
    if (data == null || data.isEmpty) {
      return 0;
    }
    return utf8.encode(data).length;
  }
}
