import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';

abstract class MesaRepository {
  Future<List<MesaData>> getAllMesa();

  Future<bool>saveMesa(MesaData mesaData);

  Future<bool>removeMesa(String mesaId);

  Future<bool>updateMesa(String mesaId, String nombre, String url, bool activo);

  Future<MesaData> getMesaById(String mesaId) async {
    try {
      final List<MesaData> mesas = await getAllMesa(); // Obtiene todas las categorías
      return mesas.firstWhere(
        (mesas) => mesas.id == mesaId,
        orElse: () => throw Exception("Mesa no encontrada"),
      );
    } catch (e) {
      throw Exception("Error al obtener la Mesa: $e");
    }
  }

}