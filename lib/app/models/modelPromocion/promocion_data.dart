


import 'package:json_annotation/json_annotation.dart';
part 'promocion_data.g.dart';

@JsonSerializable(explicitToJson: true)
class PromocionData {
    String? id;
    String? slug;
    String nombre;
    String? description;
    
    @JsonKey(name: 'image', defaultValue: '') //evita nulos
    String? image;
    double precio;
    Map<String, dynamic>? features;
    String? categoria;
    
    @JsonKey(name: 'stock_disponible')
    int? stockDisponible;
    bool activo;
    int? createdAt;
    int? updatedAt;

    PromocionData({
        this.id,
        this.slug,
        required this.nombre,
        this.description,
        this.image,
        required this.precio,
        this.features,
        this.categoria,
        this.stockDisponible,
        required this.activo,
        required this.createdAt,
        this.updatedAt
    });

    factory PromocionData.fromJson(Map<String, dynamic> data) => _$PromocionDataFromJson(data);
    Map<String, dynamic> toJson() => _$PromocionDataToJson(this);

    PromocionData copyWith({
      String? id,
      String? slug,
      String? nombre,
      String? description,
      String? image,
      double? precio,
      Map<String, dynamic>? features,
      String? categoria,
      int? stockDisponible,
      bool? activo,
      int? createdAt,
      int? updatedAt,
    }) {
      return PromocionData(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        nombre: nombre ?? this.nombre,
        description:  description ?? this.description,
        image: image ?? this.image, 
        precio: precio ?? this.precio,
        features: features ?? this.features,
        categoria: categoria ?? this.categoria,
        stockDisponible: stockDisponible ?? this.stockDisponible, 
        activo: activo ?? this.activo, 
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt
      );
    }

}