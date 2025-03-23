import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_event.dart';
import 'package:mesa_bloc/app/blocs/product/product_state.dart';
import 'package:mesa_bloc/app/models/modelProducto/product_data.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

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
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          return Column(
            children: [
              _buildHeader(context, state.products.length),
              const SizedBox(height: 20),
              _buildProductTable(context, state.products),
              const SizedBox(height: 20),
              _buildPaginationControls(state.products.length),
            ],
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("Seleccione una categoría"));
      },
    );
  }

  Widget _buildHeader(BuildContext context, int totalProducts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Productos en ${widget.categoryName} ($totalProducts)",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Agregar Nuevo",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProductTable(BuildContext context, List<ProductData> products) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentProducts = products.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: screenWidth - 310 - 10,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith((states) => AppColor.bgSideMenu),
              dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
              columnSpacing: 20,
              horizontalMargin: 16,
              columns: [
                _buildDataColumn("IMAGEN", 60),
                _buildDataColumn("NOMBRE", 150),
                _buildDataColumn("DESCRIPCION", 250),
                _buildDataColumn("PRECIO", 100),
                _buildDataColumn("ACTIVO", 80),
                _buildDataColumn("ACCIONES", 120),
              ],
              rows: currentProducts.map((product) => _productDataRow(product)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String text, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: Text(
          text,
          style: TextStyle(
            color: AppColor.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  DataRow _productDataRow(ProductData product) {
    return DataRow(
      cells: [
        DataCell(
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                width: 40,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ClipOval(
                  child: Image.asset(
                    'assets/imagen/no-image.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
        ),
        DataCell( 
          SizedBox( width: 150,
            child: Text( product.nombre, style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis ),
          ),
        ),

        DataCell(
          SizedBox( width: 250,
            child: Text( product.descripcion ?? '', style: const TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis ),
          ),
        ),

        DataCell( SizedBox( width: 100,
            child: Text( '€ ${product.precio?.toStringAsFixed(2) ?? 'N/A'}', style: const TextStyle(color: Colors.black) ),
          ),
        ),

        DataCell( SizedBox( width: 80,
            child: Icon( product.activo ? Icons.check_circle : Icons.cancel, color: product.activo ? Colors.green : Colors.red, size: 28 ),
          ),
        ),
        
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppColor.primaryColor),
                onPressed: () {
                  // Acción para editar
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: AppColor.orange),
                onPressed: () {
                  // Acción para eliminar
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(int totalProducts) {
    final totalPages = (totalProducts / rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPaginationButton(
          label: 'Anterior',
          enabled: currentPage > 0,
          onPressed: () => setState(() => currentPage--),
        ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.sideMenu,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${currentPage + 1} / $totalPages',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 20),
        _buildPaginationButton(
          label: 'Siguiente',
          enabled: (currentPage + 1) * rowsPerPage < totalProducts,
          onPressed: () => setState(() => currentPage++),
        ),
      ],
    );
  }

  Widget _buildPaginationButton({
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: enabled ? AppColor.sideMenu : Colors.grey,
      ),
      child: Text(label),
    );
  }
}
