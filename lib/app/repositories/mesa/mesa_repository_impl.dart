import 'package:dio/dio.dart';
import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';
import 'package:mesa_bloc/app/repositories/mesa/mesa_repository.dart';
import 'package:mesa_bloc/app/utils/constants.dart';

class MesaRepositoryImpl extends MesaRepository {
  final Dio _dio = Dio();
  MesaRepositoryImpl();

@override
Future<List<MesaData>> getAllMesa() async {
  try {
    final response = await _dio.get('${Constants.apiUrl}mesa');

    // 🔹 Verificar que la respuesta no sea nula
    if (response.data == null) {
      throw Exception('La respuesta de la API es nula');
    }

    // 🔹 Extraer `data` correctamente
    dynamic responseData = response.data;
    print('Código de respuesta: ${response.statusCode}');
print('Cuerpo de la respuesta: ${response.data}');

    if (responseData is Map<String, dynamic>) {
      // Verificamos si existe la clave 'data' en el mapa
      if (!responseData.containsKey('data')) {
        throw Exception('La clave "data" no está en la respuesta');
      }
      responseData = responseData['data'];
    }

    // 🔹 Aseguramos que 'data' sea una lista
    if (responseData is! List) {
      throw Exception('Formato incorrecto de respuesta: no es una lista');
    }

    if (responseData.isEmpty) {
      throw Exception('No hay mesas disponibles');
    }

    // 🔹 Mapear la lista correctamente
    return responseData.map<MesaData>((x) {
      if (x is! Map<String, dynamic>) {
        throw Exception('Elemento inválido en la lista');
      }
      return MesaData.fromJson(x);
    }).toList();

  } on DioException catch (e) {
    // Error específico para la red o la solicitud
    throw Exception('Error de red: ${e.response?.statusCode} - ${e.message}');
  } catch (e) {
    // Otro tipo de errores, como el formato de los datos o la API
    throw Exception('Error al obtener mesas: ${e.toString()}');
  }
}




  @override
  Future<bool> saveMesa(MesaData mesaData) async {
    var response = await Dio().post('${Constants.apiUrl}mesa',

      data:  mesaData.toJson(),
      options: Options(
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json'
        }
      )
    );
    if (response.statusCode != 201){
      throw Exception(response.statusMessage);
    }
    return true;
  }

 @override
  Future<bool> removeMesa(String mesaId) async {
    try{
      var response = await Dio().delete('${Constants.apiUrl}mesa/$mesaId',
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/json',
            Headers.acceptHeader: 'application/json'
          }
        )
      );
      print('hola $response');
      if (response.statusCode ==200) {
        return true;
      } else {
        throw 'erro al eliminar la mesa';
      }
    } catch (error){
      throw 'Error en la Api : $error';
    }
  }


  @override
  Future<bool> updateMesa(String mesaId, String nombre, String url, bool activo) async {
    try {
      final response = await _dio.put('${Constants.apiUrl}mesa/$mesaId',
      data:  {'nombre': nombre, 'url': url, 'activo': activo},
      options: Options(
        headers: {
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json'
        }

      ));

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar la mesa');
      }
      return true;
    } catch (e) {
      throw Exception('Error actualizado mesa: ${e.toString()}');
    }
  }
  


}