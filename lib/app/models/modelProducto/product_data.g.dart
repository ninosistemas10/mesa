// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
      id: json['id'] as String?,
      idcategoria: json['idcategoria'] as String,
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num?)?.toDouble(),
      imagen: json['imagen'] as String?,
      descripcion: json['descripcion'] as String?,
      time: json['time'] as String?,
      calorias: (json['calorias'] as num?)?.toDouble(),
      activo: json['activo'] as bool,
      createdAt: (json['createdAt'] as num?)?.toInt(),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idcategoria': instance.idcategoria,
      'nombre': instance.nombre,
      'precio': instance.precio,
      'imagen': instance.imagen,
      'descripcion': instance.descripcion,
      'activo': instance.activo,
      'time': instance.time,
      'calorias': instance.calorias,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
