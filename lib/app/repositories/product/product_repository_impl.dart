import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mesa_bloc/app/models/modelProducto/product_data.dart';
import 'package:mesa_bloc/app/repositories/product/product_repository.dart';
import 'package:mesa_bloc/app/utils/constants.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio = Dio();

  @override
  Future<List<ProductData>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _dio.get('${Constants.apiUrl}productos/categoria/$categoryId');
      if (response.data == null) {
        throw 'la respuesta del API es nula';
      }

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data == null || data.isEmpty) {
          throw 'No hay productos disponibles';
        }

        if (data is List) {
          return data.map((x) => ProductData.fromJson(x as Map<String, dynamic>)).toList();
        } else {
          throw 'Formato incorrecto de respuesta: noi es una lista';
        }
      }

      if (response.data is List) {
        if(response.data.isEmpty) {
          throw 'No hay productos disponibeles';
        }
        return (response.data as List).map((x) => ProductData.fromJson(x as Map<String, dynamic>)).toList();
      }
      throw 'Formato de respuesta invalido';

    } catch (e) {
      print('❌ Error al obtener productos: $e');
      throw Exception('Error al obtener productos: $e');
    }
  }

  @override
  Future<String> updateProductImage({ required String productId, required String fileName, Uint8List? imageBytes, File? imageFile}) async {
    try {
      final multipartFile = imageFile != null
        ? await MultipartFile.fromFile(imageFile.path, filename: fileName)
        : MultipartFile.fromBytes(imageBytes!, filename: fileName);

    final response = await _dio.put('${Constants.apiUrl}product/imagen/$productId', 
      data: FormData.fromMap({'images':multipartFile})
    );

    final String? imageUrl = response.data['data']?['images'];
    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('La API no retorno una URL valida de la imagen');
    }

    if (!imageUrl.contains('uploads/product/')) {
      print('Advertencia: la URL de la imagen tien un formato inesperado: $imageUrl ');
    }

    return imageUrl;
    } catch (e, strackTrace) {
      print('StrackTrace: $strackTrace');
      throw Exception('Error subiendo la imagennnn: ${e.toString()}');
    }
  }


  @override
  Future<bool> saveProduct(ProductData productData) async {
    var response = await Dio().post('${Constants.apiUrl}producto',
    
    data: productData.toJson(),
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
  Future<bool> removeProduct(String productId) async {
    try {
    var response = await Dio().delete('${Constants.apiUrl}producto/$productId',
    
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


  

}
