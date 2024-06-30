import 'package:equatable/equatable.dart';

abstract class ProductDeleteState extends Equatable {
  const ProductDeleteState();

  @override
  List<Object?> get props => [];
}

class ProductDeleteInitial extends ProductDeleteState {}

class ProductDeleteLoading extends ProductDeleteState {}

class ProductDeleteSuccess extends ProductDeleteState {
  final int productId;

  ProductDeleteSuccess(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductDeleteFailure extends ProductDeleteState {
  final String error;

  ProductDeleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}
