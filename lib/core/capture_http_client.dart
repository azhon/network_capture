import 'dart:io';
import 'package:network_capture/core/http_client_adapter.dart';
import 'package:network_capture/http/request/capture_http_request.dart';

/// createTime: 2023/10/20 on 11:40
/// desc:
///
/// @author azhon
class CaptureHttpClient extends HttpClientAdapter {
  CaptureHttpClient(super.origin);

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
    return _proxy(origin.get(host, port, path));
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    return _proxy(origin.post(host, port, path));
  }

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    return _proxy(origin.delete(host, port, path));
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    return _proxy(origin.put(host, port, path));
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    return _proxy(origin.head(host, port, path));
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    return _proxy(origin.deleteUrl(url));
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return _proxy(origin.getUrl(url));
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    return _proxy(origin.headUrl(url));
  }

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    return _proxy(origin.open(method, host, port, path));
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return _proxy(origin.openUrl(method, url));
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    return _proxy(origin.patch(host, port, path));
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    return _proxy(origin.patchUrl(url));
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    return _proxy(origin.postUrl(url));
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    return _proxy(origin.putUrl(url));
  }

  Future<HttpClientRequest> _proxy(Future<HttpClientRequest> future) async {
    return CaptureHttpRequest(await future);
  }
}
