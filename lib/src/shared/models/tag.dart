/// Class representing a tag
/// id: Unique identifier of the tag
/// nome: Name of the tag
library;

class Tag {
  int id;
  String name;

  Tag({required this.id, required this.name});

  // Converts a Tag object into a Map to persist in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Constructor that converts a Map into a Tag object
  Tag.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        name = map['name'];

  @override
  String toString() {
    return 'Tag{id: $id, name: $name}';
  }
}
