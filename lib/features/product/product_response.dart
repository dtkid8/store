import 'dart:convert';

class ProductResponse {
    int? id;
    String? title;
    int? price;
    String? description;
    List<String>? images;
    DateTime? creationAt;
    DateTime? updatedAt;
    ProductResponseCategory? category;

    ProductResponse({
        this.id,
        this.title,
        this.price,
        this.description,
        this.images,
        this.creationAt,
        this.updatedAt,
        this.category,
    });

    ProductResponse copyWith({
        int? id,
        String? title,
        int? price,
        String? description,
        List<String>? images,
        DateTime? creationAt,
        DateTime? updatedAt,
        ProductResponseCategory? category,
    }) => 
        ProductResponse(
            id: id ?? this.id,
            title: title ?? this.title,
            price: price ?? this.price,
            description: description ?? this.description,
            images: images ?? this.images,
            creationAt: creationAt ?? this.creationAt,
            updatedAt: updatedAt ?? this.updatedAt,
            category: category ?? this.category,
        );

    factory ProductResponse.fromJson(String str) => ProductResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        creationAt: json["creationAt"] == null ? null : DateTime.parse(json["creationAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        category: json["category"] == null ? null : ProductResponseCategory.fromMap(json["category"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "images": images == null ? [] : List<String>.from(images!.map((x) => x)),
        "creationAt": creationAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "category": category?.toMap(),
    };
}

class ProductResponseCategory {
    int? id;
    String? name;
    String? image;
    DateTime? creationAt;
    DateTime? updatedAt;

    ProductResponseCategory({
        this.id,
        this.name,
        this.image,
        this.creationAt,
        this.updatedAt,
    });

    ProductResponseCategory copyWith({
        int? id,
        String? name,
        String? image,
        DateTime? creationAt,
        DateTime? updatedAt,
    }) => 
        ProductResponseCategory(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
            creationAt: creationAt ?? this.creationAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory ProductResponseCategory.fromJson(String str) => ProductResponseCategory.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductResponseCategory.fromMap(Map<String, dynamic> json) => ProductResponseCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        creationAt: json["creationAt"] == null ? null : DateTime.parse(json["creationAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "creationAt": creationAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
