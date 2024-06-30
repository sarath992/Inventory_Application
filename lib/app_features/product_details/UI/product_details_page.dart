import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/app_features/product_details/bloc/product_details_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;
  final String productTitle;
  final ProductDetailsBloc productDetailsBloc = ProductDetailsBloc();

  ProductDetailsPage(
      {Key? key, required this.productId, required this.productTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProductDetailsBloc()..add(ProductDetailsInitialFetchEvent(productId: productId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(productTitle,style: TextStyle(color: Colors.white),),
          centerTitle: true,

        ),
        body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
          listener: (context, state) {
            if (state is ProductDetailsFetchErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailsFetchSuccessState) {
              final product = state.productDetails;
              return Center(
                child: ListView(
                  padding: EdgeInsets.all(16.0),
    children: [
      ListTile(
        title: Text('Product ID'),
        subtitle: Text('${product.id}'),
      ),
      ListTile(
        title: Text('Title'),
        subtitle: Text('${product.title}'),
      ),
      ListTile(
        title: Text('Brand'),
        subtitle: Text('${product.brand}'),
      ),
      ListTile(
        title: Text('Description'),
        subtitle: Text('${product.description}'),
      ),
      ListTile(
        title: Text('Price'),
        subtitle: Text('${product.price}'),
      ),
      ListTile(
        title: Text('Rating'),
        subtitle: Text('${product.rating}'),
      ),
      ListTile(
        title: Text('Reviews'),
        // subtitle: Text('${product.reviews}'),
         subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: product.reviews.map((review) => Text('${review.comment}')).toList(),
  ),
      ),

      ListTile(
        
        title: Text('Availability Status'),
        subtitle: Text('${product.availabilityStatus}'),
      ),
      ListTile(
        title: Text('Warranty Information'),
        subtitle: Text('${product.warrantyInformation}'),
      ),
      ListTile(
        title: Text('Shipping Information'),
        subtitle: Text('${product.shippingInformation}'),
      ),
    ],
  ),
                );
            } else if (state is ProductDetailsFetchErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Center(child: Text('Select a product to view details.'));
          },
        ),
      ),
    );
  }
}
