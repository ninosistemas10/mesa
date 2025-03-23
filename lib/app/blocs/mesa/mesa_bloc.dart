import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:mesa_bloc/app/blocs/mesa/mesa_state.dart';
import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';
import 'package:mesa_bloc/app/repositories/mesa/mesa_repository.dart';
import 'package:mesa_bloc/app/repositories/mesa/mesa_repository_impl.dart';
import 'package:equatable/equatable.dart';
part 'mesa_event.dart';

class MesaBloc extends Bloc<MesaEvent, MesaState> {
  late final MesaRepository mesaRepository;

  MesaBloc() : super(MesaState()) {
    mesaRepository = MesaRepositoryImpl();

    on<MesaInit>((event, emit) {
      emit(state.copyWith(
        loading: false,
        error: '',
      ));
    });

    on<GetAllMesa>((event, emit) async {
      try {
        emit(state.copyWith(loading: true));
        final resp = await mesaRepository.getAllMesa();
        emit(state.copyWith(
          loading: false,
          listMesa: resp,
          error: '',
        ));
      } catch (error) {
        emit(state.copyWith(
          loading: false,
          error: 'Error cargando Mesa: ${error.toString()}',
        ));
      }
    });

    on<SaveMesa>((event, emit) async{
      try {
        emit(state.copyWith(loading:  true, add: false));
        await mesaRepository.saveMesa(event.mesaData);
      
        final updateList = await mesaRepository.getAllMesa();
        final newMesa = updateList.firstWhere(
          (mesa) => mesa.nombre == event.mesaData.nombre,
          orElse: () => event.mesaData
        );

        List<MesaData> newList = [newMesa, ...updateList.where((c) => c.id != newMesa.id)];

        emit(state.copyWith(
          loading: false,
          listMesa: newList,
          error: '',
          add:  true,
        ));
      } catch (error) {
        emit(state.copyWith(
          loading: false,
          error: error is Map<String, dynamic>  ? error['message']  : 'Error al guardar Mesa',
          add: false,
        ));
      }    
    });

    on<RemoveMesa>((event, emit) async {
      try {
        emit(state.copyWith(
          loading: true,
          error: '',
          removed: false
        ));
        final success = await mesaRepository.removeMesa(event.mesaId);

        if (success) {
          emit(state.copyWith(
            loading: false,
            removed:  true,
            listMesa: state.listMesa.where((mesa) => mesa.id != event.mesaId).toList(),
          ));
        } else {
          throw 'No se pudo eliminar la Mesa';
        }
      } on DioException catch (e) {
        final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Error desconocido';
        print("❌ Error API al eliminar: $errorMessage");
        emit(state.copyWith(
          loading: false,
          error: errorMessage,
          removed: false,
        ));
      } catch (error) {
        print("❌ Error inesperado: ${error.toString()}");
        emit(state.copyWith(
          loading: false,
          error: 'Error inesperado: ${error.toString()}',
          removed: false,
        ));
      }
    });

    on<UpdatedMesa>((event, emit) async {
      emit(state.copyWith(
        loading: true,
        updated: false
      ));

      try {

        await mesaRepository.updateMesa(
          event.mesaId, 
          event.nombre, 
          event.url, 
          event.activo
        );
        
        final updatedMesa = await mesaRepository.getMesaById(event.mesaId);
        final updatedList = state.listMesa.map((mesa) {
          return mesa.id == event.mesaId ? updatedMesa : mesa;
        }).toList();

        emit(state.copyWith(
          listMesa: updatedList,
          loading: false,
          updated: true
        ));
      } catch (e) {
        emit(state.copyWith(
          error: e.toString(),
          loading: false  
        ));
      }

      
    });

  }
}