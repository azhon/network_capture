import 'dart:io';

import 'package:network_capture/http/request/http_client_request_adapter.dart';
import 'package:network_capture/http/response/capture_http_response.dart';

/// createTime: 2023/10/20 on 14:20
/// desc:
///
/// @author azhon
class CaptureHttpRequest extends HttpClientRequestAdapter {
  CaptureHttpRequest(super.origin);

  @override
  Future<HttpClientResponse> close() {
    return _proxy(origin.close());
  }

  Future<HttpClientResponse> _proxy(Future<HttpClientResponse> future) async {
    return CaptureHttpResponse(origin, await future);
  }
}
