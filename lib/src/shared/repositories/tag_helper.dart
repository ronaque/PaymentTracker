import 'package:payment_tracker/globals.dart';
import 'package:payment_tracker/src/shared/repositories/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:payment_tracker/src/shared/models/tag.dart';

import '../tag_utils.dart';

class TagHelper {
  Future<Database> get database async {
    DatabaseHelper dbHelper = DatabaseHelper();

    Database db = await dbHelper.database;
    return db;
  }

  Future<void> insertTag(Tag tag) async {
    Database? db = await database;
    await db.insert('tag', tag.toMap());
  }

  Future<List<Tag>> getAllTags() async {
    Database db = await database;
    List<Map<String, Object?>>? maps = await db.query('tag');
    return List.generate(maps.length, (i) {
      return Tag.fromMap(maps[i]);
    });
  }

  Future<List<Tag>> getCustomTags() async {
    List<String> defaultTagsList = defaultTags.keys.toList();
    Database? db = await database;

    String defaultTagsPlaceholders = defaultTagsList.map((e) => '?').join(', ');

    List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT * FROM tag WHERE name NOT IN ($defaultTagsPlaceholders)',
      defaultTagsList,
    );

    return List.generate(result.length, (i) {
      return Tag.fromMap(result[i]);
    });
  }

  Future<Tag?> getTagByName(String name) async {
    Database db = await database;

    List<Map<String, Object?>>? result = await db.query(
      'tag',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<Tag?> getTagById(int tagId) async {
    Database db = await database;

    List<Map<String, Object?>>? result = await db.query(
      'tag',
      where: 'id = ?',
      whereArgs: [tagId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> deleteTagByName(String tagName) async {
    Database db = await database;

    List<Map<String, Object?>>? tagResult =
        await db.query('tag', where: 'name = ?', whereArgs: [tagName]);
    if (tagResult.isNotEmpty) {
      Object? tagId = tagResult.first['id'];

      await db.delete('tag', where: 'id = ?', whereArgs: [tagId]);

      List<Map<String, Object?>>? noneTagResult =
          await db.query('tag', where: 'name = ?', whereArgs: ['none']);
      if (noneTagResult.isNotEmpty) {
        Object? noneTagId = noneTagResult.first['id'];

        // Update payments with the specified tag to have the 'none' tag
        await db.update('payment', {'tag_id': noneTagId},
            where: 'tag_id = ?', whereArgs: [tagId]);
      } else {
        // Insert the 'none' tag if it doesn't exist
        Tag tag = await createTag('none');
        await db.insert('tag', tag.toMap());

        // Update payments with the specified tag to have the 'none' tag
        await db.update('payment', {'tag_id': tag.id},
            where: 'tag_id = ?', whereArgs: [tagId]);
      }
    }
  }
}
