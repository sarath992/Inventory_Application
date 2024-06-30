abstract class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String title;

  AddProductEvent(this.title);
}

class FetchProductListEvent extends ProductEvent {}