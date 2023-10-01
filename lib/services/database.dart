import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper with ChangeNotifier {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      "$path/dictionary.db",
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE dictionary(word TEXT, pos TEXT, pronunciation TEXT, meanings TEXT, examples TEXT)");
      },
      version: 1,
    );
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    Database database = await initDB();
    // sometimes some data may not be of type string
    data = data.map((key, value) => MapEntry(key, value.toString()));
    // maps the given lambda function to the key, value pair
    return database.insert(
      "dictionary",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> readData() async {
    Database database = await initDB();
    return database.query("dictionary");
  }

  Future<int> deleteData(String word) async {
    Database database = await initDB();
    int del = await database
        .delete("dictionary", where: "word = ?", whereArgs: [word]);
    notifyListeners();
    return del;
  }
}
