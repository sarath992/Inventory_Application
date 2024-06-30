import 'package:equatable/equatable.dart';
import 'package:inventory_app/app_features/models/product_management/update_product.dart';

abstract class ProductUpdateState extends Equatable {
  const ProductUpdateState();

  @override
  List<Object?> get props => [];
}

class ProductUpdateInitial extends ProductUpdateState {}

class ProductUpdateLoading extends ProductUpdateState {}

class ProductUpdateSuccess extends ProductUpdateState {
  final UpdateProduct updatedProduct;

  const ProductUpdateSuccess({required this.updatedProduct});

  @override
  List<Object?> get props => [updatedProduct];
}

class ProductUpdateFailure extends ProductUpdateState {
  final String error;

  const ProductUpdateFailure({required this.error});

  @override
  List<Object?> get props => [error];
}