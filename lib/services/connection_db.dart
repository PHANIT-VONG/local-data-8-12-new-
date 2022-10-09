import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ConnectionDb {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_name');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  FutureOr<void> _onCreateDatabase(Database database, int version) async {
    await database.execute(
      'CREATE TABLE tbPeople(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, gender TEXT,address TEXT,photo TEXT)',
    );
  }
}
