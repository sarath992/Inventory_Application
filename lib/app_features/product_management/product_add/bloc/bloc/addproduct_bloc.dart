
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/app_features/models/product_list_model/product_list_model.dart';
import 'package:inventory_app/app_features/models/product_management/add_product.dart';
import 'package:inventory_app/app_features/product_management/product_add/bloc/bloc/addproduct_event.dart';
import 'package:inventory_app/app_features/product_management/product_add/bloc/bloc/addproduct_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final http.Client httpClient;

  ProductBloc({required this.httpClient}) : super(ProductInitial()) {
    on<AddProductEvent>(_onAddProduct);
     on<FetchProductListEvent>(_onFetchProductList);
  }

  void _onAddProduct(AddProductEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());

      final product = await _performPostRequest(event.title);
      emit(ProductAdded(product.id, product.title));
    } catch (e) {
      emit(ProductError('Failed to add product: $e'));
    }
  }
    void _onFetchProductList(FetchProductListEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());

      final products = await _fetchProductList();
      emit(ProductListLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to fetch product list: $e'));
    }
  }


  Future<AddProduct> _performPostRequest(String title) async {
  final url = Uri.parse('https://dummyjson.com/products/add');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'title': title}); // Add other product fields here as needed

  final response = await httpClient.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    return AddProduct.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to add product. Status code: ${response.statusCode}');
  }
}
 Future<List<Product>> _fetchProductList() async {
    final url = Uri.parse('https://dummyjson.com/products');
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch product list. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<void> close() {
    httpClient.close();
    return super.close();
  }

  
}

