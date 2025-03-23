import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:mesa_bloc/app/models/modelPromocion/promocion_data.dart';
import 'package:mesa_bloc/app/repositories/Promotion/promotion_repository.dart';
import 'package:mesa_bloc/app/utils/constants.dart';

class PromotionRepositoryImpl extends PromotionRepository {
  final Dio dio = Dio();

  @override
  Future<List<PromocionData>> getAllPromotion() async {
    try {
      final url = '${Constants.apiUrl}promocion';
      print('🟢 GET: $url');

      final response = await dio.get(url);
      
      print('🔵 Respuesta cruda: ${response.data}');

      // 1. Manejar respuesta nula
      if (response.data == null) {
        print('🟠 Respuesta nula - Retornando lista vacía');
        return [];
      }

      // 2. Verificar estructura de la respuesta
      dynamic responseData = response.data;
      
      // Si es un Map, extraer la lista de 'data'
      if (responseData is Map<String, dynamic>) {
        print('🟠 Estructura Map detectada');
        responseData = responseData['data'] ?? [];
      }

      // 3. Convertir a lista
      if (responseData is List) {
        print('🟠 Lista detectada (${responseData.length} elementos)');
        
        // Mapear solo elementos válidos
        final promociones = responseData
            .whereType<Map<String, dynamic>>()
            .map((x) => PromocionData.fromJson(x))
            .toList();

        print('🟢 Promociones parseadas: ${promociones.length}');
        print('nino: $promociones');
        return promociones;
      }

      // 4. Estructura no reconocida
      print('🔴 Formato inválido: ${responseData.runtimeType}');
      return [];

    } catch (e) {
      print('❌ Error: ${e.toString()}');
      throw 'Error obteniendo promociones: ${_cleanError(e.toString())}';
    }
  }

  String _cleanError(String error) {
    return error.replaceAll(RegExp(r'Exception:|DioError:'), '').trim();
  }

  @override
  Future<bool> savePromotion(PromocionData promotionData) async {
    try {
      final response = await dio.post(
        '${Constants.apiUrl}promocion',
        data: promotionData.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('❌ Error guardando: ${e.toString()}');
      throw 'Error guardando promoción: ${_cleanError(e.toString())}';
    }
  }

@override
Future<String> updatePromotionImage({
  required String promotionId,
  required String fileName, 
  Uint8List? imageBytes,
  File? imageFile
}) async {
  try {
    final multipartFile = imageFile != null
        ? await MultipartFile.fromFile(imageFile.path, filename: fileName)
        : MultipartFile.fromBytes(imageBytes!, filename: fileName);

    final response = await dio.put(
      '${Constants.apiUrl}promocion/imagen/$promotionId',
      data: FormData.fromMap({'image': multipartFile}),
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    // 🔼 Corrección clave: Usar 'image' en lugar de 'images'
    final String? imageUrl = response.data['data']['image']; 

    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('⚠️ La API no retornó URL válida');
    }

    print('✅ URL actualizada: $imageUrl');
    return imageUrl;

  } catch (e, stackTrace) {
    print('❌ Error crítico: $e');
    print('🔍 StackTrace: $stackTrace');
    throw Exception('Error actualizando imagen: ${e.toString()}');
  }
}

  @override
  Future<bool> removePromotion(String promotionId) async{
    try{
      var response = await Dio().delete('${Constants.apiUrl}promocion/$promotionId',
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            Headers.acceptHeader: 'application/json'
          }
        )
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw 'error al eliminar la Promocion';
      }

    } catch (error){
      throw 'Error en la API : $error';
    }
  }

  @override
  Future<bool> updatePromotion(String promotionId, String nombre, String description, bool activo, {String? image}) async {
    try {
      final response = await dio.put('${Constants.apiUrl}promocion/$promotionId',
        data: { 'nombre': nombre, 'description': description, 'activo': activo, 'image': image },
        options:  Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            Headers.acceptHeader: 'application/json'
          }
        )
      );

      if (response.statusCode != 200 ) {
        throw Exception( 'Error al actualizar la promocion' );
      }
      return true;

    } catch (error) {
      throw Exception('Error actualizando promocion: ${error.toString()}');
    }
  }

}