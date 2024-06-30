import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/app_features/product_management/product_delete/bloc/bloc/product_delete_bloc.dart';
import 'package:inventory_app/app_features/product_management/product_delete/bloc/bloc/product_delete_event.dart';
import 'package:inventory_app/app_features/product_management/product_delete/bloc/bloc/product_delete_state.dart';
import 'package:http/http.dart' as http;

class ProductDeletePage extends StatefulWidget {
  final int productId;

  ProductDeletePage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDeletePage> createState() => _ProductDeletePageState();
}

class _ProductDeletePageState extends State<ProductDeletePage> {
  final TextEditingController _titleController = TextEditingController();
  String? productName;
  final httpClient = http.Client();

  @override
  void initState() {
    super.initState();
    _fetchProductDetails(widget.productId);
  }

  void _fetchProductDetails(int productId) async {
    try {
      var response = await httpClient.get(
        Uri.parse('https://dummyjson.com/products/$productId'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          productName = jsonResponse['title']; 
          _titleController.text = productName ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch product details')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDeleteBloc(httpClient: httpClient),
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: Colors.blue,
        title: const Text(
          'Delete-Product',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        ),
        body: BlocConsumer<ProductDeleteBloc, ProductDeleteState>(
          listener: (context, state) {
            if (state is ProductDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product with id ${state.productId} has been deleted successfully')),
              );
              Navigator.of(context).pop(); 
            } else if (state is ProductDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete product: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Product ID'),
                      initialValue: widget.productId.toString(),
                      readOnly: true, 
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Product Title'),
                      readOnly: true, 
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        int productId = widget.productId;
                        if (productId > 0) {
                          context.read<ProductDeleteBloc>().add(ProductDeleteRequested(productId, _titleController.text));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter a valid Product ID')),
                          );
                        }
                      },
                      child: Text('Delete Product'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
