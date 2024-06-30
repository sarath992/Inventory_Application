import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'product_delete_event.dart';
import 'product_delete_state.dart';

class ProductDeleteBloc extends Bloc<ProductDeleteEvent, ProductDeleteState> {
  final http.Client httpClient;

  ProductDeleteBloc({required this.httpClient}) : super(ProductDeleteInitial()) {
    on<ProductDeleteRequested>(_onDeleteProductRequested);
  }

  void _onDeleteProductRequested(
      ProductDeleteRequested event, Emitter<ProductDeleteState> emit) async {
    try {
      emit(ProductDeleteLoading());

      final response = await http.delete(
        Uri.parse('https://dummyjson.com/products/${event.productId}'),
      );

      if (response.statusCode == 200) {
        emit(ProductDeleteSuccess(event.productId));
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      emit(ProductDeleteFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    httpClient.close();
    return super.close();
  }
}
