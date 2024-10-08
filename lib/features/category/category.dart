// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:store/features/category/category_response.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  @HiveField(3)
  DateTime creationAt;

  @HiveField(4)
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

  factory Category.fromResponse(CategoryResponse response) {
    return Category(
      id: response.id ?? 0,
      name: response.name ?? "",
      image: response.image ?? "",
      creationAt: response.creationAt ?? DateTime(0),
      updatedAt: response.updatedAt ?? DateTime(0),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductResponseCategory(id: $id, name: $name, image: $image, creationAt: $creationAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
