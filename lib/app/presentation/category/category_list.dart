import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_state.dart';
import 'package:mesa_bloc/app/blocs/menu/menu_bloc.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
import 'package:mesa_bloc/app/presentation/category/category_edit.dart';
import 'package:mesa_bloc/app/presentation/category/category_add.dart';
import 'package:mesa_bloc/app/presentation/category/category_delete.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';


class CategoryList extends StatefulWidget {
  final Function(String, {String? categoryId}) updatePage;
  const CategoryList({super.key, required this.updatePage});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int currentPage = 0;
  final int rowsPerPage = 10;

  @override
  void initState() {
    context.read<CategoryBloc>().add(GetAllCategory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        _handleErrors(context, state);
        return _buildMainContent(context, state);
      },
    );
  }

  void _handleErrors(BuildContext context, CategoryState state) {
    if (state.error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      });
    }
  }

  Widget _buildMainContent(BuildContext context, CategoryState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildTableContainer(context, state),
          const SizedBox(height: 20),
          _buildPaginationControls(state),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Todas las Categorías",
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
          onPressed: () => CategoryAdd.show(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Agregar Nueva",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTableContainer(BuildContext context, CategoryState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          _buildTableContent(context, state),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.sideMenu,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Row(
        children: [
          SizedBox(width: 80, child: _buildHeaderText('')),
          Expanded(flex: 2, child: _buildHeaderText('NOMBRE')),
          Expanded(flex: 3, child: _buildHeaderText('DESCRIPCIÓN')),
          Expanded(flex: 1, child: _buildHeaderText('ESTADO')),
          SizedBox(width: 100, child: _buildHeaderText('ACCIONES')),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildTableContent(BuildContext context, CategoryState state) {
    if (state.loading) return _buildLoadingIndicator();
    if (state.listPromotion.isEmpty) return _buildEmptyState();
    
    final currentCategories = state.listPromotion.sublist(
      currentPage * rowsPerPage,
      (currentPage + 1) * rowsPerPage < state.listPromotion.length
          ? (currentPage + 1) * rowsPerPage
          : state.listPromotion.length,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: ListView.separated(
        itemCount: currentCategories.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => 
            _buildTableRow(currentCategories[index]),
      ),
    );
  }

  Widget _buildTableRow(CategoryData category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: GestureDetector(
              onTap: () => _handleImageUpdate(context, category.id ?? ''),
              child: _buildCategoryImage(category.images),
            ),
          ),
          
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              category.nombre.isNotEmpty ? category.nombre : "Sin nombre",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              category.description?.isNotEmpty == true
                  ? category.description!
                  : "Sin descripción",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Icon(
              category.activo ? Icons.check_circle : Icons.cancel,
              color: category.activo ? Colors.green : Colors.red,
              size: 28,
            ),
          ),

          SizedBox(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  color: AppColor.blueDark,
                  onPressed: () => _showEditDialog(context, category),
                ),
                const SizedBox(width: 10),
                _buildActionButton(
                  icon: Icons.delete,
                  color: Colors.red,
                  onPressed: () => _showDeleteDialog(context, category),
                ),

                const SizedBox(width: 10),
                _buildActionButton(
                  icon: Icons.arrow_forward, 
                  color: AppColor.pink, 
                  onPressed: () {
                    print('holaNinosisi ${category.id}');
                    print('holaNinosisi ${category.nombre}');
                    context.read<MenuBloc>().add(SelectMenuEvent(
                    
                      page: 'Producto',
                      categoryId: category.id.toString(),
                      categoryName: category.nombre.toString()
                      
                      
                      
                    ));

                  }  
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 24),
      color: color,
      onPressed: onPressed,
      splashRadius: 20,
    );
  }

  Widget _buildLoadingIndicator() {
    return  SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Text(
          "No hay categorías disponibles",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPaginationControls(CategoryState state) {
    final totalPages = (state.listPromotion.length / rowsPerPage).ceil();
    
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
          enabled: (currentPage + 1) * rowsPerPage < state.listPromotion.length,
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

  Widget _buildCategoryImage(String? imageUrl) {
  final fixedUrl = _fixImageUrl(imageUrl);
  
  return SizedBox(
    width: 50,
    height: 50,
    child: ClipOval(
      child: fixedUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: fixedUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, __, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: AppColor.primaryColor,
                ),
              ),
              errorWidget: (_, __, ___) => _buildImagePlaceholder(),
            )
          : _buildImagePlaceholder(),
     ),
    );
  }

  Widget _buildImagePlaceholder() {
  return ClipOval(
    child: Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported, 
          color: Colors.grey,
          size: 28,
        ),
      ),
    ),
  );
}

  String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains("localhost")) {
      return url;
      //return url.replaceAll("localhost", Constants.localhost);
    }
    if (!url.startsWith("http")) {
      //return "http://${Constants.localhost}:8081/$url";
      return "http://localhost:8081/$url";

    }
    return url;
  }

  void _showEditDialog(BuildContext context, CategoryData category) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
  }

  void _showDeleteDialog(BuildContext context, CategoryData category) {
    showDialog(
      context: context,
      builder: (context) => DeleteCategoryDialog(categoryId: category.id ?? ''),
    );
  }

  Future<void> _handleImageUpdate(BuildContext context, String categoryId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.bytes == null) return;

      if (!context.mounted) return;

      context.read<CategoryBloc>().add(
        UpdateCategoryImage(
          categoryId: categoryId,
          imageBytes: file.bytes!,
          fileName: file.name,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Imagen actualizada exitosamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar la imagen"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}