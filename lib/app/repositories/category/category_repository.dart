import 'dart:typed_data';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
import 'package:universal_io/io.dart';

abstract class CategoryRepository {
  
  Future<List<CategoryData>> getAllCategory();

  Future<String> updateCategoryImage({ // 🔹 Cambiado de List<String> a String
    required String categoryId,
    required String fileName,
    Uint8List? imageBytes,
    File? imageFile, // Opcional si necesitas mantener compatibilidad
  });

  Future<bool>saveCategory(CategoryData categoryData);

  Future<bool> removeCategory(String categoryId);

  Future<bool> updateCategory(String categoryId, String nombre, String description, bool activo, {String? images});

  Future<CategoryData> getCategoryById(String categoryId) async {
    try {
      final List<CategoryData> categories = await getAllCategory(); // Obtiene todas las categorías
      return categories.firstWhere(
        (category) => category.id == categoryId,
        orElse: () => throw Exception("Categoría no encontrada"),
      );
    } catch (e) {
      throw Exception("Error al obtener la categoría: $e");
    }
  }

}

