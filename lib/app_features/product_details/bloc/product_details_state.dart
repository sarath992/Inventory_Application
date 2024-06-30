part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsState {}
abstract class ProductdetailsActionState extends ProductDetailsState{}


final class ProductDetailsInitial extends ProductDetailsState {}

final class ProductDetailsLoading extends ProductDetailsState {}


class ProductDetailsFetchSuccessState extends ProductDetailsState{
final ProductDetailsModel productDetails;

  ProductDetailsFetchSuccessState({required this.productDetails});

}

class ProductDetailsFetchErrorState extends ProductDetailsState {
  final String error;

  ProductDetailsFetchErrorState({required this.error});
}
