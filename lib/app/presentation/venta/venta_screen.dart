import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_state.dart';
import 'package:mesa_bloc/app/blocs/product/product_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_event.dart';
import 'package:mesa_bloc/app/blocs/product/product_state.dart';
import 'package:mesa_bloc/app/utils/constants.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  _VentaScreenState createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  String? categoriaSeleccionada;
  String? hoveredCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(GetAllCategory());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error.isNotEmpty) {
                  return Center(child: Text(state.error));
                }
                if (state.listPromotion.isEmpty) {
                  return const Center(child: Text('No hay categorías disponibles'));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.listPromotion.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                categoriaSeleccionada = category.id.toString();
                              });
                              context.read<ProductBloc>().add(LoadProductsByCategory(category.id.toString()));
                            },
                            child: Container(
                              width: 80, // Más pequeño
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: hoveredCategory == category.nombre ? Colors.yellow : Colors.green,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCategoryImage(category.images),
                                  const SizedBox(height: 5),
                                  Text(
                                    category.nombre,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: hoveredCategory == category.nombre ? Colors.red : Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Expanded(child: buildProductList()), 
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage(String? imageUrl) {
    final fixedUrl = _fixImageUrl(imageUrl);

    return SizedBox(
      width: 60, // Más pequeño
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: fixedUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: fixedUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, __, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (_, __, ___) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 20,
        ),
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

  Widget buildProductList() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 productos por fila
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7, // Ajuste para mostrar mejor las imágenes
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: _fixImageUrl(product.imagen), // Arreglando la imagen del producto
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120, // Tamaño fijo para evitar distorsión
                          errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Text(
                            product.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '€ ${product.precio?.toStringAsFixed(2) ?? 'N/A'}',
                            style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
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
}
