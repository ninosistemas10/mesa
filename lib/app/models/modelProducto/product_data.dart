
import 'package:json_annotation/json_annotation.dart';

part 'product_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductData {
  String? id;
  String idcategoria;  
  String nombre;
  double? precio;
  String? imagen;  
  String? descripcion;
  bool activo;
  String? time;
  double? calorias;
  int? createdAt;
  int? updatedAt;

  ProductData({
    this.id,
    required this.idcategoria,
    required this.nombre,
    this.precio,
    this.imagen,
    this.descripcion,
    this.time,
    this.calorias,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> data) => _$ProductDataFromJson(data);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}
