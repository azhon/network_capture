import 'dart:io';

/// createTime: 2023/10/20 on 15:06
/// desc:
///
/// @author azhon
class HttpBean {
  final String? method;
  final String? url;
  final HttpHeaders? requestHeaders;
  HttpHeaders? responseHeaders;
  String? response;

  HttpBean({
    this.method,
    this.url,
    this.requestHeaders,
  });
}
