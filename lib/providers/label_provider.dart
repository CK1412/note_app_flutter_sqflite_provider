import 'package:flutter/material.dart';
import '../helpers/label_database_helper.dart';
import '../models/label.dart';

class LabelProvider with ChangeNotifier {
  List<Label> _items = [];

  List<Label> get items => [..._items];

  Future fetchAndSet() async {
    _items = await LabelDatabaseHelper.instance.getAllRecords();
    notifyListeners();
  }

  Future add(Label label) async {
    _items.insert(0, label);
    notifyListeners();
    await LabelDatabaseHelper.instance.insertRecord(label);
  }

  Future update(Label label) async {
    final index = _items.indexWhere((e) => e.id == label.id);
    if (index != -1) {
      _items[index] = label;
      notifyListeners();
      await LabelDatabaseHelper.instance.updateRecord(label);
    }
  }

  Future delete(int id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    await LabelDatabaseHelper.instance.deleteRecord(id);
  }

  Future deleteAll() async {
    _items.clear();
    notifyListeners();
    await LabelDatabaseHelper.instance.deleteAllRecords();
  }
}
