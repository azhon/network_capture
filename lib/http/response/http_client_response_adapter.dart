import 'dart:async';
import 'dart:io';

/// createTime: 2023/10/20 on 14:49
/// desc:
///
/// @author azhon
abstract class HttpClientResponseAdapter implements HttpClientResponse {
  final HttpClientResponse origin;

  HttpClientResponseAdapter(this.origin);

  @override
  Future<bool> any(bool Function(List<int> element) test) {
    return origin.any(test);
  }

  @override
  Stream<List<int>> asBroadcastStream({
    void Function(StreamSubscription<List<int>> subscription)? onListen,
    void Function(StreamSubscription<List<int>> subscription)? onCancel,
  }) {
    return origin.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) {
    return origin.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) {
    return origin.asyncMap(convert);
  }

  @override
  Stream<R> cast<R>() {
    return origin.cast();
  }

  @override
  X509Certificate? get certificate => origin.certificate;

  @override
  HttpClientResponseCompressionState get compressionState =>
      origin.compressionState;

  @override
  HttpConnectionInfo? get connectionInfo => origin.connectionInfo;

  @override
  Future<bool> contains(Object? needle) {
    return origin.contains(needle);
  }

  @override
  int get contentLength => origin.contentLength;

  @override
  List<Cookie> get cookies => origin.cookies;

  @override
  Future<Socket> detachSocket() {
    return origin.detachSocket();
  }

  @override
  Stream<List<int>> distinct([
    bool Function(List<int> previous, List<int> next)? equals,
  ]) {
    return origin.distinct(equals);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return origin.drain(futureValue);
  }

  @override
  Future<List<int>> elementAt(int index) {
    return origin.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(List<int> element) test) {
    return origin.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) {
    return origin.expand(convert);
  }

  @override
  Future<List<int>> get first => origin.first;

  @override
  Future<List<int>> firstWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) {
    return origin.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(
    S initialValue,
    S Function(S previous, List<int> element) combine,
  ) {
    return origin.fold(initialValue, combine);
  }

  @override
  Future<void> forEach(void Function(List<int> element) action) {
    return origin.forEach(action);
  }

  @override
  Stream<List<int>> handleError(
    Function onError, {
    bool Function(dynamic error)? test,
  }) {
    return origin.handleError(onError, test: test);
  }

  @override
  HttpHeaders get headers => origin.headers;

  @override
  bool get isBroadcast => origin.isBroadcast;

  @override
  Future<bool> get isEmpty => origin.isEmpty;

  @override
  bool get isRedirect => origin.isRedirect;

  @override
  Future<String> join([String separator = '']) {
    return origin.join(separator);
  }

  @override
  Future<List<int>> get last => origin.last;

  @override
  Future<List<int>> lastWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) {
    return origin.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => origin.length;

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) {
    return origin.map(convert);
  }

  @override
  bool get persistentConnection => origin.persistentConnection;

  @override
  Future<dynamic> pipe(StreamConsumer<List<int>> streamConsumer) {
    return origin.pipe(streamConsumer);
  }

  @override
  String get reasonPhrase => origin.reasonPhrase;

  @override
  Future<HttpClientResponse> redirect([
    String? method,
    Uri? url,
    bool? followLoops,
  ]) {
    return origin.redirect(method, url, followLoops);
  }

  @override
  List<RedirectInfo> get redirects => origin.redirects;

  @override
  Future<List<int>> reduce(
    List<int> Function(List<int> previous, List<int> element) combine,
  ) {
    return origin.reduce(combine);
  }

  @override
  Future<List<int>> get single => origin.single;

  @override
  Future<List<int>> singleWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) {
    return origin.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<List<int>> skip(int count) {
    return origin.skip(count);
  }

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) {
    return origin.skipWhile(test);
  }

  @override
  int get statusCode => origin.statusCode;

  @override
  Stream<List<int>> take(int count) {
    return origin.take(count);
  }

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) {
    return origin.takeWhile(test);
  }

  @override
  Stream<List<int>> timeout(Duration timeLimit,
      {void Function(EventSink<List<int>> sink)? onTimeout}) {
    return origin.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<List<int>>> toList() {
    return origin.toList();
  }

  @override
  Future<Set<List<int>>> toSet() {
    return origin.toSet();
  }

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) {
    return origin.where(test);
  }

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return origin.listen(onData, onDone: onDone, cancelOnError: cancelOnError);
  }
}
