import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_state.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';

import 'package:mesa_bloc/app/repositories/category/category_repository.dart';
import 'package:mesa_bloc/app/repositories/category/category_repository_impl.dart';

part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  late final CategoryRepository categoryRepository;

  CategoryBloc() : super(CategoryState()) {
    categoryRepository = CategoryRepositoryImpl();

    on<CategoryInit>((event, emit) {
      emit(state.copyWith(
        loading: false,
        error: '',
      ));
    });

    on<GetAllCategory>((event, emit) async {
      try {
        emit(state.copyWith(loading: true));
        final resp = await categoryRepository.getAllCategory();
        emit(state.copyWith(
          loading: false,
          listCategory: resp,
          error: '',
        ));
      } catch (error) {
        emit(state.copyWith(
          loading: false,
          error: 'Error cargando categorías: ${error.toString()}',
        ));
      }
    });

    on<UpdateCategoryImage>((event, emit) async {
      try {
        emit(state.copyWith(imageUpdateStatus: ImageUpdateStatus.loading));

        final String imageUrl = await categoryRepository.updateCategoryImage(
          categoryId: event.categoryId,
          fileName: event.fileName,
          imageBytes: event.imageBytes,
        );

        // 🔹 Agregar timestamp para evitar caché de imágenes
        final updatedCategories = state.listPromotion.map((category) {
          return category.id == event.categoryId
            ? category.copyWith(  images: '$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}')
            : category;
            }).toList();

            emit(state.copyWith(
              listCategory: updatedCategories,
              imageUpdateStatus: ImageUpdateStatus.success,
            ));
      
      } catch (e) {
        //print('❌ Error subiendo imagen: $e');
        emit(state.copyWith(
          imageUpdateStatus: ImageUpdateStatus.error,
          error: 'Error al actualizar imagen: ${e.toString()}',
        ));
      }
    });

    on<SaveCategory>((event, emit) async {
  try {
    emit(state.copyWith(loading: true, add: false));

    // 1. Guardar la categoría en el backend
    await categoryRepository.saveCategory(event.categoryData);
    
    // 2. Obtener lista actualizada del servidor
    final updatedList = await categoryRepository.getAllCategory();

    // 3. Buscar la categoría recién añadida en la lista actualizada
    final newCategory = updatedList.firstWhere(
      (category) => category.nombre == event.categoryData.nombre, // Comparar por nombre u otro campo único
      orElse: () => event.categoryData, // Si no la encuentra, usa la original
    );

    // 4. Crear una nueva lista con la categoría en la primera posición
    List<CategoryData> newList = [newCategory, ...updatedList.where((c) => c.id != newCategory.id)];

    // 5. Emitir el estado con la lista corregida
    emit(state.copyWith(
      loading: false,
      listCategory: newList,
      error: '',
      add: true,
    ));
  } catch (error) {
    emit(state.copyWith(
      loading: false,
      error: error is Map<String, dynamic> 
          ? error['message'] 
          : 'Error al guardar categoría',
      add: false,
    ));
  }
});




    on<RemoveCategory>((event, emit) async {
      try {
        emit(state.copyWith(
          loading: true,
          error: '',
          removed: false, // 🔹 Resetear estado de eliminación
        ));

        final success = await categoryRepository.removeCategory(event.categoryId);

        if (success) {
          print("✅ Eliminación exitosa en API");

          emit(state.copyWith(
            loading: false,
            removed: true,
            listCategory: state.listPromotion
              .where((category) => category.id != event.categoryId)
              .toList(), // 🔹 Actualización inmediata
          ));
        } else {
          throw "No se pudo eliminar la categoría";
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

  
   on<UpdateCategory>((event, emit) async {
  emit(state.copyWith(loading: true, isUpdated: false)); // 🔹 Reinicia isUpdated antes de actualizar
  try {
    final currentCategory = await categoryRepository.getCategoryById(event.categoryId);
    
    await categoryRepository.updateCategory(
      event.categoryId,
      event.nombre,
      event.description,
      event.activo,
      images: currentCategory.images, // 🔹 Mantiene la imagen actual
    );
    
    final updatedCategory = await categoryRepository.getCategoryById(event.categoryId);

// Reemplaza solo la categoría modificada en la lista existente
final updatedList = state.listPromotion.map((category) {
  return category.id == event.categoryId ? updatedCategory : category;
}).toList();

emit(state.copyWith(listCategory: updatedList, loading: false, isUpdated: true));

  } catch (e) {
    emit(state.copyWith(error: e.toString(), loading: false));
  }
});


  }
}
