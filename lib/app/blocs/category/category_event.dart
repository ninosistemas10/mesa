part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryInit extends CategoryEvent {}

class GetAllCategory extends CategoryEvent {}

class UpdateCategoryImage extends CategoryEvent {
  final String categoryId;
  final File? imageFile;      // El archivo de imagen, opcional
  final Uint8List? imageBytes; // Los bytes de la imagen, opcionales
  final String fileName;      // El nombre del archivo, requerido

  const UpdateCategoryImage({
    required this.categoryId,
    this.imageFile,
    this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [
        categoryId,
        // Usamos los valores por defecto si son nulos para evitar errores en las comparaciones
        imageFile?.path ?? '',   // Usamos `.path` para obtener la ruta del archivo
        imageBytes ?? Uint8List(0),  // Un array vacío si no hay bytes
        fileName,
      ];
}

class SaveCategory extends CategoryEvent{
  final CategoryData categoryData;
  const  SaveCategory({required this.categoryData});
}

class RemoveCategory extends CategoryEvent {
  final String categoryId;
  const RemoveCategory({required this.categoryId});
}

class UpdateCategory extends CategoryEvent {
  final String categoryId;
  final String nombre;
  final String description;
  final bool activo;
  

  const UpdateCategory({
    required this.categoryId,
    required this.nombre,
    required this.description,
    required this.activo,
    
  });

  @override
  List<Object> get props => [categoryId, nombre, description, activo];
}