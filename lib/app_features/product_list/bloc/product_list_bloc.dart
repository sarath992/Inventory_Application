import 'package:bloc/bloc.dart';
import 'package:inventory_app/app_features/models/product_list_model/product_list_model.dart';
import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'product_list_event.dart';
part 'product_list_state.dart';
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final http.Client httpClient;

  ProductListBloc({required this.httpClient}) : super(ProductListInitial()) {
    on<ProductListInitialFetchEvent>(_onInitialFetch);
    on<ProductListSearchEvent>(_onSearch);
    on<ProductListUpdateEvent>(_onUpdate); 
  }

  void _onInitialFetch(ProductListInitialFetchEvent event, Emitter<ProductListState> emit) async {
    try {
      emit(ProductListLoadingState());
      final products = await _fetchProductList();
      emit(ProductListFetchSuccessState(productList: products));
    } catch (e) {
      emit(ProductListFetchErrorState(error: e.toString()));
    }
  }

  void _onSearch(ProductListSearchEvent event, Emitter<ProductListState> emit) async {
    try {
      final products = await _fetchProductList();
      final filteredProducts = products.where((product) =>
        product.title.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(ProductListLoading(filteredProducts));
    } catch (e) {
      emit(ProductListFetchErrorState(error:e.toString()));
    }
  }

  void _onUpdate(ProductListUpdateEvent event, Emitter<ProductListState> emit) async {
    try {
      final products = await _fetchProductList(); 
      emit(ProductListFetchSuccessState(productList: products));
    } catch (e) {
      emit(ProductListFetchErrorState(error: e.toString()));
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

  Future<List<Product>> _searchProductList(String query) async {
    final url = Uri.parse('https://dummyjson.com/products/search?q=$query');
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search product list. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<void> close() {
    httpClient.close();
    return super.close();
  }
}

