import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/network_capture.dart';
import 'package:network_capture/util/constant.dart';

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
      _saveHttp(err.requestOptions, err.response, err);
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

    final table = NetworkHistoryTable(
      method: request.method,
      url: request.uri.toString(),
      params: _getParams(request),
      startTime: startTime?.millisecondsSinceEpoch,
      requestHeaders: request.headers,
    );
    table.endTime = DateTime.now().millisecondsSinceEpoch;
    if (response == null) {
      table.reasonPhrase = err?.message;
    } else {
      table.responseHeaders = table.transformHeaders(response.headers);
      table.statusCode = response.statusCode;
      table.reasonPhrase = response.statusMessage;

      ///判断返回的数据类型
      final String contentType =
          table.responseHeaders?[HttpHeaders.contentTypeHeader] ?? '';
      if (contentType.contains(Constant.jsonH)) {
        table.response = jsonEncode(response.data);
      } else {
        table.response = response.data.toString();
      }
      table.contentLength = _getContentLength(table.response);
    }

    ///保存
    AppDb.instance.insert(NetworkHistoryTable.tableName, table.toMap());
  }

  ///参数处理
  String? _getParams(RequestOptions request) {
    final uriParams = request.uri.queryParameters;
    if (request.method == Constant.get) {
      return uriParams.isNotEmpty ? jsonEncode(uriParams) : null;
    }
    if (request.data is FormData) {
      final params = <String, dynamic>{};
      final formData = request.data as FormData;
      for (final map in formData.fields) {
        params[map.key] = map.value;
      }
      for (final file in formData.files) {
        params[file.key] = file.value.filename;
      }
      return jsonEncode(params);
    }
    if (request.data != null) {
      return jsonEncode(request.data);
    }
    return null;
  }

  int _getContentLength(String? data) {
    if (data == null || data.isEmpty) {
      return 0;
    }
    return utf8.encode(data).length;
  }
}
