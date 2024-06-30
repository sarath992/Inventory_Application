import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/app_features/product_management/product_add/bloc/bloc/addproduct_bloc.dart';
import 'package:inventory_app/app_features/product_management/product_add/bloc/bloc/addproduct_event.dart';
import 'package:inventory_app/app_features/product_management/product_add/bloc/bloc/addproduct_state.dart';


class ProductPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
    final httpClient = http.Client();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => ProductBloc(httpClient: httpClient),
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product added: ${state.title}with id ${state.id}')),
              );
               Navigator.pop(context);
            } else if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Product Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isNotEmpty) {
                        context.read<ProductBloc>().add(AddProductEvent(title));
                      }
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
