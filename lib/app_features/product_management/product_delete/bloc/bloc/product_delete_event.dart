import 'package:equatable/equatable.dart';

abstract class ProductDeleteEvent extends Equatable {
  const ProductDeleteEvent();

  @override
  List<Object?> get props => [];
}

class ProductDeleteRequested extends ProductDeleteEvent {
  final int productId;
  final String title;

  ProductDeleteRequested(this.productId, this.title);

  @override
  List<Object?> get props => [productId];
}
