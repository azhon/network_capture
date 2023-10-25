import 'dart:io';

/// createTime: 2023/10/20 on 11:52
/// desc:
///
/// @author azhon
abstract class HttpClientAdapter implements HttpClient {
  final HttpClient origin;

  HttpClientAdapter(this.origin);

  @override
  set autoUncompress(bool autoUncompress) {
    origin.autoUncompress = autoUncompress;
  }

  @override
  bool get autoUncompress => origin.autoUncompress;

  @override
  set connectionTimeout(Duration? connectionTimeout) {
    origin.connectionTimeout = connectionTimeout;
  }

  @override
  Duration? get connectionTimeout => origin.connectionTimeout;

  @override
  set idleTimeout(Duration idleTimeout) {
    origin.idleTimeout = idleTimeout;
  }

  @override
  Duration get idleTimeout => origin.idleTimeout;

  @override
  set maxConnectionsPerHost(int? maxConnectionsPerHost) {
    origin.maxConnectionsPerHost = maxConnectionsPerHost;
  }

  @override
  int? get maxConnectionsPerHost => origin.maxConnectionsPerHost;

  @override
  set userAgent(String? userAgent) {
    origin.userAgent = userAgent;
  }

  @override
  String? get userAgent => origin.userAgent;

  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String? realm)? f) {
    origin.authenticate = f;
  }

  @override
  set authenticateProxy(
    Future<bool> Function(String host, int port, String scheme, String? realm)?
        f,
  ) {
    origin.authenticateProxy = f;
  }

  @override
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)? callback) {
    origin.badCertificateCallback = callback;
  }

  @override
  set connectionFactory(
      Future<ConnectionTask<Socket>> Function(
        Uri url,
        String? proxyHost,
        int? proxyPort,
      )? f) {
    origin.connectionFactory = f;
  }

  @override
  set findProxy(String Function(Uri url)? f) {
    origin.findProxy = f;
  }

  @override
  set keyLog(Function(String line)? callback) {
    origin.keyLog = callback;
  }

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {
    origin.addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {
    origin.addProxyCredentials(host, port, realm, credentials);
  }

  @override
  void close({bool force = false}) {
    origin.close(force: force);
  }
}
