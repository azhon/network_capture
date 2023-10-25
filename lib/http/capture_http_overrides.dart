import 'dart:io';

import 'package:network_capture/http/capture_http_client.dart';

/// createTime: 2023/10/20 on 11:18
/// desc:
///
/// @author azhon
class CaptureHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpOverrides.global = null;
    final httpClient = CaptureHttpClient(HttpClient(context: context));
    HttpOverrides.global = this;
    return httpClient;
  }
}
