import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/app_features/Repository/update_repository.dart';
import 'package:inventory_app/app_features/product_management/product_update/bloc/productupdate_bloc.dart';
import 'package:inventory_app/app_features/product_management/product_update/bloc/productupdate_event.dart';
import 'package:inventory_app/app_features/product_management/product_update/bloc/productupdate_state.dart';

class ProductUpdatePage extends StatefulWidget {
  final int productId;

  ProductUpdatePage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductUpdatePageState createState() => _ProductUpdatePageState();
}

class _ProductUpdatePageState extends State<ProductUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  late ProductUpdateBloc _productUpdateBloc;

  @override
  void initState() {
    super.initState();
    _productUpdateBloc = ProductUpdateBloc(repository: Repository());
    _fetchProductDetails(); 
  }

  void _fetchProductDetails() async {
    var client = http.Client();

    try {
      var response = await client.get(Uri.parse('https://dummyjson.com/products/${widget.productId}'));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String productTitle = jsonResponse['title']; 
        _titleController.text = productTitle; 
      } else {
        
        print('Failed to fetch product details: ${response.statusCode}');
      }
    } catch (e) {
      
      print('Error fetching product details: $e');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _productUpdateBloc,
      child: Scaffold(
        appBar: AppBar(
         backgroundColor: Colors.blue,
        title: const Text(
          'Update Product',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        ),
        body: BlocListener<ProductUpdateBloc, ProductUpdateState>(
          listener: (context, state) {
            if (state is ProductUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product updated successfully')),
              );
              Navigator.of(context).pop();
            } else if (state is ProductUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update product: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<ProductUpdateBloc, ProductUpdateState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Product ID'),
                      initialValue: widget.productId.toString(),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Product Title'),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        int productId = widget.productId;
                        if (productId > 0) {
                          context.read<ProductUpdateBloc>().add(UpdateProductRequested(productId: productId, title: _titleController.text));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter a valid Product ID')),
                          );
                        }
                      },
                      child: Text('Update Product'),
                    ),
                    if (state is ProductUpdateLoading) ...[
                      SizedBox(height: 20.0),
                      Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productUpdateBloc.close();
    _titleController.dispose();
    super.dispose();
  }
}
