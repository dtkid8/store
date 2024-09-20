// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
    int id;
    String name;
    String image;
    DateTime creationAt;
    DateTime updatedAt;
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });


  Category copyWith({
    int? id,
    String? name,
    String? image,
    DateTime? creationAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'creationAt': creationAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      creationAt: DateTime.fromMillisecondsSinceEpoch(map['creationAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductResponseCategory(id: $id, name: $name, image: $image, creationAt: $creationAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.image == image &&
      other.creationAt == creationAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      creationAt.hashCode ^
      updatedAt.hashCode;
  }
}
