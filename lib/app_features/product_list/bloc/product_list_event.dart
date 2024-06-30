part of 'product_list_bloc.dart';

abstract class ProductListEvent {}

class ProductListInitialFetchEvent extends ProductListEvent{}

class ProductListSearchEvent extends ProductListEvent{

   final String query;

  ProductListSearchEvent({required this.query});
}
class ProductListUpdateEvent extends ProductListEvent {} 