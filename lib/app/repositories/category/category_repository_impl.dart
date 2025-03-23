import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
import 'package:mesa_bloc/app/repositories/category/category_repository.dart';
import 'package:mesa_bloc/app/utils/constants.dart';


class CategoryRepositoryImpl extends CategoryRepository {
  final Dio _dio = Dio();

  @override
  Future<List<CategoryData>> getAllCategory() async {
    try {
      final response = await _dio.get('${Constants.apiUrl}category');
      if (response.data == null) {
        throw 'La respuesta de la API es nula';
      }

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data']; // Extraer solo el array
        if (data == null || data.isEmpty) {
          throw 'No hay categorías disponibles';
        }

        // 🔹 POSIBLE ERROR AQUÍ: Asegurarnos de que 'data' es una lista de Map<String, dynamic>
        if (data is List) {
          return data.map((x) => CategoryData.fromJson(x as Map<String, dynamic>)).toList();
        } else {
          throw 'Formato incorrecto de respuesta: no es una lista';
        }
      }

      if (response.data is List) {
        if (response.data.isEmpty) {
          throw 'No hay categorías disponibles';
        }

        // 🔹 Asegurar que el mapeo se haga correctamente
        return (response.data as List)
          .map((x) => CategoryData.fromJson(x as Map<String, dynamic>))
          .toList();
      }

      throw 'Formato de respuesta inválido';

    } on DioError catch (e) {
      throw 'Error de red: ${e.response?.statusCode} - ${e.message}';
    } on TypeError catch (e) {
      throw 'Error de parsing: ${e.toString()}';
    } catch (e) {
      throw 'Error al obtener categorías: ${e.toString()}';
    }
  }

@override
Future<String> updateCategoryImage({ required String categoryId, required String fileName, Uint8List? imageBytes, File? imageFile }) async {
  try {
    final multipartFile = imageFile != null
        ? await MultipartFile.fromFile(imageFile.path, filename: fileName)
        : MultipartFile.fromBytes(imageBytes!, filename: fileName); 

    final response = await _dio.put( '${Constants.apiUrl}category/imagen/$categoryId',
      data: FormData.fromMap({'image': multipartFile}),
    );

    // 🔹 Imprimir la respuesta completa para depuración
    print('📌 Respuesta completa de la API: ${response.data}');

    // 🔹 Extraer correctamente la URL de la imagen
    final String? imageUrl = response.data['data']?['images'];

    // 🔹 Validar si la API devolvió una URL válida
    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('⚠️ La API noooo retornó una URL válida de la imagen');
    }

    // 🔹 Imprimir la URL recibida para verificar
    print('✅ URL recibida de la API: $imageUrl');

    // 🔹 Si la URL no tiene el formato esperado, solo advertir en consola
    if (!imageUrl.contains('/uploads/categorias/')) {
      print('⚠️ Advertencia: La URL de imagen tiene un formato inesperado: $imageUrl');
    }

    return imageUrl; 
  } catch (e, stackTrace) {
    print('❌ Error subiendo imagendddddd: $e');
    print('📌 StackTrace: $stackTrace'); // Para ver más detalles del error
    throw Exception('Error subiendo imagennnnn: ${e.toString()}');
  }
}


  @override
  Future<bool> saveCategory(CategoryData categoryData) async {
    var response = await Dio().post('${Constants.apiUrl}category',
    
    data: categoryData.toJson(),
    options: Options(
      headers: {
        Headers.contentTypeHeader: 'application/json',
        Headers.acceptHeader: 'application/json'
      }
    ));
    print(response);
    if (response.statusCode != 201) {
      throw Exception(response.statusMessage);
    }
    return true;
  }

  @override
  Future<bool> removeCategory(String categoryId) async {
    try {
    var response = await Dio().delete('${Constants.apiUrl}category/$categoryId',
    
      options: Options(
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json'
        }
      )
    );
    print(response);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw 'error al eliminar category';
    }
    }catch (error) {
      throw 'Error en la API : $error';
    }
    

  }

  @override
Future<bool> updateCategory(String categoryId, String nombre, String description, bool activo, {String? images}) async {
  try {
    final response = await _dio.put('${Constants.apiUrl}category/$categoryId',
      data: {'nombre': nombre, 'description': description, 'activo': activo, 'images': images},
      options: Options(
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json'
        }
      ));
    
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la categoría');
    }
    return true;
  } catch (e) {
    print('Error actualizando categoría: ${e.toString()}');
    throw Exception('Error actualizando categoría: ${e.toString()}');
  }
}
}
