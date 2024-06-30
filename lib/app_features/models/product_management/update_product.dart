
import 'dart:convert';

UpdateProduct updateProductFromJson(String str) =>
    UpdateProduct.fromJson(json.decode(str));

String updateProductToJson(UpdateProduct data) => json.encode(data.toJson());

class UpdateProduct {
  int id;
  String title;

  UpdateProduct({
    required this.id,
    required this.title,
  });
  UpdateProduct copyWith({
    int? id,
    String? title,
  }) {
    return UpdateProduct(
      title: title ?? this.title,
      id: id ?? this.id,
    );
  }

  factory UpdateProduct.fromJson(Map<String, dynamic> json) => UpdateProduct(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
