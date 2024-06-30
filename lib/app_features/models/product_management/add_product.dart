import 'dart:convert';

AddProduct addProductFromJson(String str) =>
    AddProduct.fromJson(json.decode(str));

String addProductToJson(AddProduct data) => json.encode(data.toJson());

class AddProduct {
  int id;
  String title;

  AddProduct({
    required this.id,
    required this.title,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) => AddProduct(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
