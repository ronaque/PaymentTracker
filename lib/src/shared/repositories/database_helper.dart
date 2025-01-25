import 'package:path/path.dart';
import 'package:payment_tracker/globals.dart' as globals;
import 'package:payment_tracker/src/shared/models/tag.dart';
import 'package:payment_tracker/src/shared/tag_utils.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> get database async {
    Database db = await _initDatabase();
    return db;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 4,
            onCreate: (db, version) async {
              await _createTagTable(db);
              await _createPaymentTable(db);
              await initializeDefaultTags();
            }));
  }

  Future<void> _createTagTable(Database db) async {
    await db.execute('''
      CREATE TABLE tag(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  Future<void> _createPaymentTable(Database db) async {
    await db.execute('''
      CREATE TABLE payment(
        id INTEGER PRIMARY KEY,
        date TEXT,
        amount REAL,
        tag_id INTEGER,
        description TEXT,
        mode INTEGER,
        installments INTEGER,
        FOREIGN KEY(tag_id) REFERENCES tags(id)
      )
      ''');
  }

  Future<void> initializeDefaultTags() async {
    globals.defaultTags.forEach((key, value) async {
      Tag tag = await createTag(key);
      Database? db = await database;
      await db.insert('tag', tag.toMap());
    });
  }
}
