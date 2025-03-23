
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mesa_bloc/app/models/modelPromocion/promocion_data.dart';
import 'package:mesa_bloc/app/repositories/Promotion/promotion_repository.dart';
import 'package:mesa_bloc/app/repositories/Promotion/promotion_repository_impl.dart';

part 'promotion_event.dart';
part 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  late final PromotionRepository promotionRepository;

  PromotionBloc() : super(PromotionState()) {
    promotionRepository = PromotionRepositoryImpl();

    on<PromotionInit>(_onPromotionInit);
    on<GetAllPromotion>(_onGetAllPromotion);
    on<UpdatedPromotionImage>(_onUpdatedPromotionImage);
    on<SavePromotion>(_onSavePromotion);
  }

  void _onPromotionInit(PromotionInit event, Emitter<PromotionState> emit) {
    emit(state.copyWith(loading: false, error: ''));
  }

  Future<void> _onGetAllPromotion(
      GetAllPromotion event, Emitter<PromotionState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final resp = await promotionRepository.getAllPromotion();

      emit(state.copyWith(
        loading: false,
        error: resp.isEmpty ? 'No hay promociones' : '',
        listPromotion: resp,
        refreshFlag: DateTime.now().millisecondsSinceEpoch,
      ));
    } catch (error) {
      emit(state.copyWith(
        loading: false,
        error: 'Error: ${error.toString().replaceAll('Exception: ', '')}',
      ));
    }
  }

Future<void> _onUpdatedPromotionImage(
  UpdatedPromotionImage event, Emitter<PromotionState> emit) async {
  try {
    // Emitimos un estado de carga cuando comienza el proceso
    emit(state.copyWith(imageUpdatedStatus: ImageUpdatedStatus.loading));
    
    // Llamada a la API para actualizar la imagen de la promoción
    final imageUrl = await promotionRepository.updatePromotionImage(
      promotionId: event.promotionId,
      fileName: event.fileName,
      imageBytes: event.imageBytes,
    );

    // Crear una nueva lista de promociones para aplicar el cambio de imagen
    final newList = List<PromocionData>.from(state.listPromotion);

    // Encontrar el índice de la promoción que estamos actualizando
    final index = newList.indexWhere((p) => p.id == event.promotionId);
    
    // Si se encuentra la promoción, actualizamos su imagen
    if (index != -1) {
      newList[index] = newList[index].copyWith(
        image: '${_fixImageUrl(imageUrl)}?t=${DateTime.now().millisecondsSinceEpoch}'
      );
    }

    // Emitimos el estado con la nueva lista de promociones y el estado de éxito
    emit(state.copyWith(
      listPromotion: newList,
      imageUpdatedStatus: ImageUpdatedStatus.success,
      refreshFlag: DateTime.now().millisecondsSinceEpoch, // Para forzar la recarga en UI
      error: '',
    ));
    
  } catch (e) {
    // Si ocurre un error, emitimos el estado de error con el mensaje adecuado
    emit(state.copyWith(
      imageUpdatedStatus: ImageUpdatedStatus.error,
      error: 'Error: ${e.toString().replaceAll('Exception: ', '')}'
    ));
  }
}


String _fixImageUrl(String url) {
  return url.replaceAll("localhost", "172.20.10.2");
}
  Future<void> _onSavePromotion(
      SavePromotion event, Emitter<PromotionState> emit) async {
    try {
      emit(state.copyWith(loading: true, add: false));
      await promotionRepository.savePromotion(event.promotionData);

      final updateList = await promotionRepository.getAllPromotion();
      final newPromotion = updateList.firstWhere(
          (promotion) => promotion.nombre == event.promotionData.nombre,
          orElse: () => event.promotionData);

      List<PromocionData> newList = [
        newPromotion,
        ...updateList.where((c) => c.id != newPromotion.id)
      ];

      emit(state.copyWith(
        loading: false,
        listPromotion: newList,
        error: '',
        add: true,
        refreshFlag: DateTime.now().millisecondsSinceEpoch,
      ));
    } catch (error) {
      emit(state.copyWith(
        loading: false,
        error: error is Map<String, dynamic>
            ? error['message']
            : 'Error al guardar Promotion',
        add: false,
      ));
    }
  }
}