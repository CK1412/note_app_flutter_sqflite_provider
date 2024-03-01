import '../models/note.dart';
import 'database_helper.dart';

class NoteDatabaseHelper {
  static final NoteDatabaseHelper instance = NoteDatabaseHelper._init();
  NoteDatabaseHelper._init();

  Future<Note> getRecord(int id) async {
    final db = await DatabaseHelper.instance.database;

    final records = await db.query(
      noteTable,
      where: '${NoteField.id} = ?',
      whereArgs: [id],
    );

    if (records.isNotEmpty) {
      return Note.fromJson(records.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> getAllRecords() async {
    final db = await DatabaseHelper.instance.database;

    final records = await db.query(
      noteTable,
      orderBy: '${NoteField.createdTime} DESC',
    );

    return records.map((e) => Note.fromJson(e)).toList();
  }

  Future<int> insertRecord(Note note) async {
    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      noteTable,
      note.toJson(),
    );
  }

  Future<int> updateRecord(Note note) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      noteTable,
      note.toJson(),
      where: '${NoteField.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> changeFieldValueOfAllRecords({
    required String field,
    required String value,
  }) async {
    final db = await DatabaseHelper.instance.database;

    return await db.rawUpdate('UPDATE $noteTable SET $field = ?', [value]);
  }

  Future<int> deleteRecord(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      noteTable,
      where: '${NoteField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllRecords() async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(noteTable);
  }
}
