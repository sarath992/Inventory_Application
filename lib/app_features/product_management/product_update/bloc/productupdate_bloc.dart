
import 'package:bloc/bloc.dart';
import 'package:inventory_app/app_features/Repository/update_repository.dart';
import 'package:inventory_app/app_features/product_management/product_update/bloc/productupdate_event.dart';
import 'package:inventory_app/app_features/product_management/product_update/bloc/productupdate_state.dart';


class ProductUpdateBloc extends Bloc<ProductUpdateEvent, ProductUpdateState> {
  final Repository repository;

  ProductUpdateBloc({required this.repository}) : super(ProductUpdateInitial()) {
    on<UpdateProductRequested>(_onUpdateProductRequested);
  }

  void _onUpdateProductRequested(
      UpdateProductRequested event, Emitter<ProductUpdateState> emit) async {
    emit(ProductUpdateLoading());
    try {
      final updatedProduct = await repository.updateProduct(event.productId , event.title);
      print(updatedProduct.title);
      emit(ProductUpdateSuccess(updatedProduct: updatedProduct));
    } catch (e) {
      emit(ProductUpdateFailure(error: e.toString()));
    }
  }

}
