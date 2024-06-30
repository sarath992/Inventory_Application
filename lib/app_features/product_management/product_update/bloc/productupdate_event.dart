import 'package:equatable/equatable.dart';

abstract class ProductUpdateEvent extends Equatable {
  const ProductUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateProductRequested extends ProductUpdateEvent {
  final int productId;
  final String title;

  const UpdateProductRequested({required this.productId, required this.title});

  @override
  List<Object> get props => [productId, title];
}
