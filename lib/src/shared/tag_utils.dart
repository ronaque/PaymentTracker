import 'package:payment_tracker/src/shared/components/alert_dialog.dart';
import 'package:payment_tracker/src/shared/models/tag.dart';
import 'package:payment_tracker/src/shared/repositories/tag_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Tag> createTag(String nome) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('tag_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('tag_id', id);
  return Tag(id: id, name: nome);
}

Future<bool> insertTag(Tag tag) async {
  if (tag.name.isEmpty) {
    print('Nome da tag não pode ser vazio');
    return false;
  }
  TagHelper tagHelper = TagHelper();
  tagHelper.insertTag(tag);

  return true;
}

Future<List<Tag>> getAllTags() async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getAllTags();
}

Future<List<Tag>> getCustomTags() async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getCustomTags();
}

Future<Tag?> getTagByName(String name) async {
  TagHelper tagHelper = TagHelper();
  print('Getting tag by name: $name');
  return tagHelper.getTagByName(name);
}

Future<Tag?> getTagById(int tagId) async {
  TagHelper tagHelper = TagHelper();
  return tagHelper.getTagById(tagId);
}

Future<void> deleteTagByName(String nome) async {
  TagHelper tagHelper = TagHelper();
  tagHelper.deleteTagByName(nome);
}
