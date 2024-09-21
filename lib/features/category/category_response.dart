import 'dart:convert';

List<CategoryResponse> categoryResponseFromMap(String str) => List<CategoryResponse>.from(json.decode(str).map((x) => CategoryResponse.fromMap(x)));

String categoryResponseToMap(List<CategoryResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CategoryResponse {
    int? id;
    String? name;
    String? image;
    DateTime? creationAt;
    DateTime? updatedAt;

    CategoryResponse({
        this.id,
        this.name,
        this.image,
        this.creationAt,
        this.updatedAt,
    });

    CategoryResponse copyWith({
        int? id,
        String? name,
        String? image,
        DateTime? creationAt,
        DateTime? updatedAt,
    }) => 
        CategoryResponse(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
            creationAt: creationAt ?? this.creationAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory CategoryResponse.fromMap(Map<String, dynamic> json) => CategoryResponse(
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
