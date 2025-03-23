// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promocion_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromocionData _$PromocionDataFromJson(Map<String, dynamic> json) =>
    PromocionData(
      id: json['id'] as String?,
      slug: json['slug'] as String?,
      nombre: json['nombre'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      precio: (json['precio'] as num).toDouble(),
      features: json['features'] as Map<String, dynamic>?,
      categoria: json['categoria'] as String?,
      stockDisponible: (json['stock_disponible'] as num?)?.toInt(),
      activo: json['activo'] as bool,
      createdAt: (json['createdAt'] as num?)?.toInt(),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PromocionDataToJson(PromocionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'nombre': instance.nombre,
      'description': instance.description,
      'image': instance.image,
      'precio': instance.precio,
      'features': instance.features,
      'categoria': instance.categoria,
      'stock_disponible': instance.stockDisponible,
      'activo': instance.activo,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
