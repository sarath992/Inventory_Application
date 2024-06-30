part of 'product_list_bloc.dart';

@immutable
abstract class ProductListState {}

abstract class ProductListActionState extends ProductListState{}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState{
  ProductListLoading(List<Product> filteredProducts);
}

class ProductListFetchSuccessState extends ProductListState{
 final List<Product> productList;

  ProductListFetchSuccessState({required this.productList});
}

class ProductListSearchState extends ProductListState{
  final List<Product> query;

  ProductListSearchState({required this.query});
  
}

class ProductListFetchErrorState extends ProductListState {
  final String error;

  ProductListFetchErrorState({required this.error});

}

class ProductListLoadingState extends ProductListState {}
