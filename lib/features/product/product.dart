// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:store/features/product/product_response.dart';

import '../category/category.dart' as model;

class Product {
  final int id;
  final String title;
  final int price;
  final String description;
  final List<String> images;
  final DateTime creationAt;
  final DateTime updatedAt;
  final model.Category category;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
    required this.category,
  });

  Product copyWith({
    int? id,
    String? title,
    int? price,
    String? description,
    List<String>? images,
    DateTime? creationAt,
    DateTime? updatedAt,
    model.Category? category,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'images': images,
      'creationAt': creationAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'category': category.toMap(),
    };
  }

  factory Product.fromResponse(ProductResponse response) {
    return Product(
      id: response.id ?? 0,
      title: response.title ?? "",
      price: response.price ?? 0,
      description: response.description ?? "",
      images: response.images?.map((e) => e).toList() ?? [],
      creationAt: response.creationAt ?? DateTime(0),
      updatedAt: response.updatedAt ?? DateTime(0),
      category: model.Category(
        id: response.category?.id ?? 0,
        name: response.category?.name ?? "",
        image: response.category?.image ?? "",
        creationAt: response.creationAt ?? DateTime(0),
        updatedAt: response.updatedAt ?? DateTime(0),
      ),
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      price: map['price'] as int,
      description: map['description'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      creationAt: DateTime.fromMillisecondsSinceEpoch(map['creationAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      category: model.Category.fromMap(map['category'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, description: $description, images: $images, creationAt: $creationAt, updatedAt: $updatedAt, category: $category)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.price == price &&
        other.description == description &&
        listEquals(other.images, images) &&
        other.creationAt == creationAt &&
        other.updatedAt == updatedAt &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        price.hashCode ^
        description.hashCode ^
        images.hashCode ^
        creationAt.hashCode ^
        updatedAt.hashCode ^
        category.hashCode;
  }
}
