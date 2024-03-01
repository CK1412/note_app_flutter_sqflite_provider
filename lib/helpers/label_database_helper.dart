import '../models/label.dart';
import 'database_helper.dart';

class LabelDatabaseHelper {
  static final LabelDatabaseHelper instance = LabelDatabaseHelper._init();
  LabelDatabaseHelper._init();

  Future<Label> getRecord(int id) async {
    final db = await DatabaseHelper.instance.database;

    final records = await db.query(
      labelTable,
      where: '${LabelField.id} = ?',
      whereArgs: [id],
    );

    if (records.isNotEmpty) {
      return Label.fromJson(records.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Label>> getAllRecords() async {
    final db = await DatabaseHelper.instance.database;

    final records = await db.query(
      labelTable,
      orderBy: '${LabelField.id} DESC',
    );

    return records.map((e) => Label.fromJson(e)).toList();
  }

  Future<int> insertRecord(Label label) async {
    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      labelTable,
      label.toJson(),
    );
  }

  Future<int> updateRecord(Label label) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      labelTable,
      label.toJson(),
      where: '${LabelField.id} = ?',
      whereArgs: [label.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      labelTable,
      where: '${LabelField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllRecords() async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(labelTable);
  }
}
