
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/app_features/product_details/UI/product_details_page.dart';
import 'package:inventory_app/app_features/product_list/bloc/product_list_bloc.dart';
import 'package:inventory_app/app_features/product_management/product_add/UI/add_product_page.dart';
import 'package:inventory_app/app_features/product_management/product_delete/Ui/product_delete.dart';
import 'package:inventory_app/app_features/product_management/product_update/UI/product_update_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductListBloc productListBloc =
      ProductListBloc(httpClient: http.Client());
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    productListBloc.add(ProductListInitialFetchEvent());
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.blue,
        title: const Text(
          'Product List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
             Tooltip(
              message: 'Add Product',
               child: IconButton(
                     icon: Icon(Icons.add),
                     onPressed: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductPage()));
                     },
                   ),
             ),
          Tooltip(
            message: 'Sign Out',
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchText = '';
                                });
                              },
                            )
                          : null,
                    ),
              
              onChanged: (query) {
                setState(() {
                        _searchText = query;
                      });
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<ProductListBloc, ProductListState>(
              bloc: productListBloc,
              listenWhen: (previous, current) =>
                  current is ProductListActionState,
              buildWhen: (previous, current) =>
                  current is! ProductListActionState,
              listener: (context, state) {
                if (state is ProductListUpdateEvent) {
                  productListBloc.add(ProductListUpdateEvent());
                }
              },
              builder: (context, state) {
                if (state is ProductListFetchSuccessState) {
                  final successState = state as ProductListFetchSuccessState;
                  return Container(
                    color: Colors.grey.shade200,
                    child: ListView.separated(
                      itemCount: successState.productList.length,
                      itemBuilder: (context, index) {
                        final product = successState.productList[index];
                        return ListTile(
                          title: Text(product.title),
                          subtitle:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.category.name),
                                   Text(
                                'Price: \$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                                ],
                              ),
            trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Tooltip(
        message:'Update Product',
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductUpdatePage(productId: product.id),
              ),
            );
          },
        ),
      ),
      Tooltip(
        message:'Delete',
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDeletePage(productId: product.id,)));
          },
        ),
      ),
    ],
  ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  productId: product.id,
                                  productTitle: product.title,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
