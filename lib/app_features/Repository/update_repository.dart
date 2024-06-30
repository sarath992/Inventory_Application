import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_app/app_features/models/product_management/update_product.dart';

class Repository {

  Future<UpdateProduct> updateProduct(int product, [String? title]) async {
    final uri = Uri.parse('https://dummyjson.com/products/${product}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}) ,
    );

    if (response.statusCode == 200) {

      return UpdateProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }
}
