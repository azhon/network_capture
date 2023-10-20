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
  Map<String, dynamic>? requestHeaders;
  Map<String, dynamic>? responseHeaders;
  String? response;

  NetworkHistoryTable({
    this.id,
    this.method,
    this.url,
    this.requestHeaders,
    this.responseHeaders,
    this.response,
  });

  Map<String, String> transformHeaders(HttpHeaders? headers) {
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
      'requestHeaders': jsonEncode(requestHeaders),
      'responseHeaders': jsonEncode(responseHeaders),
      'response': response,
    };
  }

  NetworkHistoryTable.fromMap(Map<String, Object?> map) {
    id = int.parse(map['id']!.toString());
    method = map['method'].toString();
    url = map['url'].toString();
    requestHeaders = jsonDecode(map['requestHeaders'].toString());
    responseHeaders = jsonDecode(map['responseHeaders'].toString());
    response = map['response'].toString();
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
