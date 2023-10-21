import 'dart:convert';
import 'dart:io';

/// createTime: 2023/10/20 on 14:20
/// desc:
///
/// @author azhon
abstract class HttpClientRequestAdapter implements HttpClientRequest {
  final HttpClientRequest origin;

  HttpClientRequestAdapter(this.origin);

  @override
  set bufferOutput(bool bufferOutput) {
    origin.bufferOutput = bufferOutput;
  }

  @override
  set contentLength(int contentLength) {
    origin.contentLength = contentLength;
  }

  @override
  set encoding(Encoding encoding) {
    origin.encoding = encoding;
  }

  @override
  set followRedirects(bool followRedirects) {
    origin.followRedirects = followRedirects;
  }

  @override
  set maxRedirects(int maxRedirects) {
    origin.maxRedirects = maxRedirects;
  }

  @override
  set persistentConnection(bool persistentConnection) {
    origin.persistentConnection = persistentConnection;
  }

  @override
  bool get bufferOutput => origin.bufferOutput;

  @override
  int get contentLength => origin.contentLength;

  @override
  Encoding get encoding => origin.encoding;

  @override
  bool get followRedirects => origin.followRedirects;

  @override
  int get maxRedirects => origin.maxRedirects;

  @override
  bool get persistentConnection => origin.persistentConnection;

  @override
  HttpConnectionInfo? get connectionInfo => origin.connectionInfo;

  @override
  List<Cookie> get cookies => origin.cookies;

  @override
  Future<HttpClientResponse> get done => origin.done;

  @override
  HttpHeaders get headers => origin.headers;

  @override
  String get method => origin.method;

  @override
  Uri get uri => origin.uri;

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {
    origin.abort(exception, stackTrace);
  }

  @override
  void add(List<int> data) {
    origin.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    origin.addError(error, stackTrace);
  }

  @override
  Future flush() {
    return origin.flush();
  }

  @override
  void write(Object? object) {
    origin.write(object);
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    origin.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    origin.writeCharCode(charCode);
  }

  @override
  void writeln([Object? object = '']) {
    origin.writeln(object);
  }
}
