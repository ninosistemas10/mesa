import 'package:json_annotation/json_annotation.dart';

part 'category_data.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryData {
  String? id;
  String nombre;
  String? description;

  @JsonKey(name: 'images', defaultValue: '') // 🔹 Evita nulos
  String images;

  bool activo;
  int? createdAt;
  int? updatedAt;

  CategoryData({
    this.id,
    required this.nombre,
    this.description,
    this.images = '',  // 🔹 Si no hay imagen, al menos será un string vacío
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);

  // Método copyWith para mantener coherencia
  CategoryData copyWith({
    String? id,
    String? nombre,
    String? description,
    String? images, // 🔹 Aquí nos aseguramos de no recibir `null`
    bool? activo,
    int? createdAt,
    int? updatedAt,
  }) {
    return CategoryData(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      description: description ?? this.description,
      images: images ?? this.images, // 🔹 Usa la imagen existente si no se proporciona una nueva
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
