import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductsByCategory extends ProductEvent {
  final String categoryId;
  LoadProductsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class UpdateProductImage extends ProductEvent {
  final String productId;
  final File? imageFile;      // El archivo de imagen, opcional
  final Uint8List? imageBytes; // Los bytes de la imagen, opcionales
  final String fileName;      // El nombre del archivo, requerido

  UpdateProductImage({
    required this.productId,
    this.imageFile,
    this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [
        productId,
        // Usamos los valores por defecto si son nulos para evitar errores en las comparaciones
        imageFile?.path ?? '',   // Usamos `.path` para obtener la ruta del archivo
        imageBytes ?? Uint8List(0),  // Un array vacío si no hay bytes
        fileName,
      ];
}