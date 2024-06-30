import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../models/product_details_model/product_details_model.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<ProductDetailsInitialFetchEvent>(productDetailsInitialFetchEvent);
  }

  FutureOr<void> productDetailsInitialFetchEvent(
      ProductDetailsInitialFetchEvent event,
      Emitter<ProductDetailsState> emit) async {
    emit(ProductDetailsLoading());
    var client = http.Client();
    try {
      var response = await client
          .get(Uri.parse('https://dummyjson.com/products/${event.productId}'));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        ProductDetailsModel productDetails =
            ProductDetailsModel.fromJson(jsonResponse);
        emit(ProductDetailsFetchSuccessState(productDetails: productDetails));
      } else {
        emit(ProductDetailsFetchErrorState(
            error: 'Failed to fetch product details.'));
      }
    } catch (e) {
      emit(ProductDetailsFetchErrorState(error: e.toString()));
    }
  }
}
