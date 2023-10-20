import 'dart:convert';
import 'dart:io';

/// createTime: 2023/10/20 on 21:29
/// desc:
///
/// @author azhon
class NetworkHistoryTable {
  static const String tableName = 'history';
  int? id;
  String? method;
  String? url;
  HttpHeaders? requestHeaders;
  HttpHeaders? responseHeaders;
  String? response;

  NetworkHistoryTable({
    this.id,
    this.method,
    this.url,
    this.requestHeaders,
    this.responseHeaders,
    this.response,
  });

  Map<String, String> headers(HttpHeaders? headers) {
    final Map<String, String> map = {};
    headers?.forEach((name, values) {
      map[name] = values.first;
    });
    return map;
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'method': method,
      'url': url,
      'requestHeaders': jsonEncode(headers(requestHeaders)),
      'responseHeaders': jsonEncode(headers(responseHeaders)),
      'response': response,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  static String createTable() {
    // ignore: leading_newlines_in_multiline_strings
    return '''create table $tableName (
    id integer primary key autoincrement,
    method text,
    url text,
    requestHeaders text,
    responseHeaders text,
    response text
    )
    ''';
  }

  static String drop() {
    return 'DROP TABLE $tableName';
  }
}
