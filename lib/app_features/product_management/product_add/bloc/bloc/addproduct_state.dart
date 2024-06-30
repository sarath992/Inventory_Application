import 'package:inventory_app/app_features/models/product_list_model/product_list_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductAdded extends ProductState {
  final int id;
  final String title;

  ProductAdded(this.id, this.title);
}

class ProductError extends ProductState {
  final String error;

  ProductError(this.error);
}
class ProductListLoaded extends ProductState {
  final List<Product> products;

  ProductListLoaded(this.products);

}