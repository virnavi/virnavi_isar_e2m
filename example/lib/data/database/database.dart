import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/entities.dart';

class Database {
  static Database? _instance;

  static Database get shared {
    if (_instance == null) {
      throw Exception('Database not Initialized');
    }
    return _instance!;
  }

  static Future<Database> initialize() async {
    if (_instance == null) {
      _instance = Database();
      await _instance!.init();
    }

    return _instance!;
  }

  late Isar db;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [
        NoteEntitySchema,
        UserEntitySchema
      ],
      name: "virnavi_isar_e2m_example",
      directory: dir.path,
    );
  }
}
