import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/label.dart';
import '../models/note.dart';

class DatabaseHelper {
  static const dbName = 'note_app.db';

  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDb(dbName);

    return _database!;
  }

  Future _initDb(String dbName) async {
    final appDir = await getApplicationDocumentsDirectory();

    final String path = join(appDir.path, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE $noteTable (
              ${NoteField.id} INTEGER PRIMARY KEY,
              ${NoteField.title} TEXT, 
              ${NoteField.content} TEXT, 
              ${NoteField.label} TEXT,
              ${NoteField.imagePaths} TEXT,
              ${NoteField.bgColor} INTEGER, 
              ${NoteField.createdTime} TEXT
            )
          ''',);

        await db.execute('''
            CREATE TABLE $labelTable (
              ${LabelField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
              ${LabelField.title} TEXT
            )
          ''',);
      },
    );
  }
}
