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
  int? startTime;
  Map<String, dynamic>? responseHeaders;
  String? response;
  int? endTime;
  int? statusCode;
  int? contentLength;

  NetworkHistoryTable({
    this.id,
    this.method,
    this.url,
    this.requestHeaders,
    this.startTime,
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
      'startTime': startTime,
      'responseHeaders': jsonEncode(responseHeaders),
      'response': response,
      'endTime': endTime,
      'statusCode': statusCode,
      'contentLength': contentLength,
    };
  }

  NetworkHistoryTable.fromMap(Map<String, Object?> map) {
    id = int.parse(map['id']!.toString());
    method = map['method'].toString();
    url = map['url'].toString();
    requestHeaders = jsonDecode(map['requestHeaders'].toString());
    startTime = int.parse(map['startTime']?.toString() ?? '0');
    responseHeaders = jsonDecode(map['responseHeaders'].toString());
    response = map['response'].toString();
    endTime = int.parse(map['endTime']?.toString() ?? '0');
    statusCode = int.parse(map['statusCode']?.toString() ?? '0');
    contentLength = int.parse(map['contentLength']?.toString() ?? '0');
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
    startTime integer,
    responseHeaders text,
    response text,
    endTime integer,
    statusCode integer,
    contentLength integer
    )
    ''';
  }

  static String drop() {
    return 'DROP TABLE $tableName';
  }
}
