part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsEvent {}

class ProductDetailsInitialFetchEvent extends ProductDetailsEvent{
  final int productId;

  ProductDetailsInitialFetchEvent({required this.productId});


}

