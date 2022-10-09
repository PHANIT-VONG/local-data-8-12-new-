import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/people_model.dart';
import '../services/connection_db.dart';

class Repository {
  late ConnectionDb _connectionDb;
  static Database? _database;

  Repository() {
    _connectionDb = ConnectionDb();
  }

  Future<Database?> get database async {
    // Restart Database ==================================
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, 'db_name');
    // await deleteDatabase(path);
    // debugPrint('Database Restarted');
    //==========================

    if (_database != null) {
      return _database;
    }
    _database = await _connectionDb.setDatabase();
    return _database;
  }

  insertPeople(PeopleModel data) async {
    var con = await database;
    return await con!.rawInsert(
      'INSERT INTO tbPeople(name, gender,address,photo) VALUES(?, ?, ?, ?)',
      [data.name, data.gender, data.address, data.photo],
    );
  }

  selectPeople() async {
    var con = await database;
    return await con!.query('tbPeople');
  }

  deletePeople(int id) async {
    var con = await database;
    return await con!.delete('tbPeople', where: "id = ?", whereArgs: [id]);
  }

  updatePeople(data, int id) async {
    var con = await database;
    return await con!.update('tbPeople', data, where: "id= ?", whereArgs: [id]);
  }
}
