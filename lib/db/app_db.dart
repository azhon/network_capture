import 'package:network_capture/db/table/network_history_table.dart';
import 'package:sqflite/sqflite.dart';

/// createTime: 2023/10/20 on 21:26
/// desc:
///
/// @author azhon
class AppDb {
  final String _dbName = 'networkCapture.db';
  late String _path;
  late Database _db;

  factory AppDb() => _getInstance();

  static AppDb get instance => _getInstance();
  static AppDb? _instance;

  static AppDb _getInstance() {
    _instance ??= AppDb._internal();
    return _instance!;
  }

  AppDb._internal();

  Future<bool> init() async {
    final databasesPath = await getDatabasesPath();
    _path = '$databasesPath/$_dbName';
    _db = await open();
    return true;
  }

  Future<Database> open() async {
    return openDatabase(
      _path,
      version: 1,
      onCreate: (db, version) async {
        ///create tables
        await db.execute(NetworkHistoryTable.createTable());
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();
        await db.execute(NetworkHistoryTable.drop());
        await batch.commit();
      },
    );
  }

  Future<int> insert(String table, Map<String, Object?> values) {
    return _db.insert(table, values);
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) {
    return _db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return _db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }
}
