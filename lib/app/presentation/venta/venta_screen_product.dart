import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_event.dart';
import 'package:mesa_bloc/app/blocs/product/product_state.dart';

import 'package:mesa_bloc/app/utils/constants.dart';

class ProductList extends StatefulWidget {
  final String categoryId;
  final String? categoryName;

  const ProductList({super.key, required this.categoryId, this.categoryName});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int currentPage = 0;
  final int rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryId));
  }

  Widget _buildProductList() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: _fixImageUrl(product.imagen),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            product.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '€ ${product.precio?.toStringAsFixed(2) ?? 'N/A'}',
                            style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("Seleccione una categoría"));
      },
    );
  }

  Widget _buildCategoryImage(String? imageUrl) {
    final fixedUrl = _fixImageUrl(imageUrl);
    return SizedBox(
      width: 80,
      height: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: fixedUrl.isNotEmpty
            ? CachedNetworkImage(imageUrl: fixedUrl, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported, color: Colors.grey, size: 28),
      ),
    );
  }

  String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains("localhost")) {
      return url.replaceAll("localhost", Constants.localhost);
    }
    if (!url.startsWith("http")) {
      return "http://${Constants.localhost}:8081/$url";
    }
    return url;
  }
}


