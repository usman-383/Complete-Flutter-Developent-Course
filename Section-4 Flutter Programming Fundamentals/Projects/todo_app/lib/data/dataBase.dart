import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  static const String boxName = 'todos';
  static const String todosKey = 'todos';

  /// Initialize Hive and open the box.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  /// Return the underlying box instance.
  static Box get box => Hive.box(boxName);

  /// Return a listenable for the box so UI can auto-update.
  static ValueListenable<Box> listenable() => Hive.box(boxName).listenable();

  /// Read todos list from the box. Returns empty list when none stored.
  static List getTodos() {
    final box = Hive.box(boxName);
    final stored = box.get(todosKey);
    if (stored != null && stored is List) return List.from(stored);
    return <dynamic>[];
  }

  /// Save todos list to the box.
  static Future<void> saveTodos(List todos) async {
    final box = Hive.box(boxName);
    await box.put(todosKey, todos);
  }
}
