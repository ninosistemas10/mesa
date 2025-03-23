
import 'package:json_annotation/json_annotation.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_message.dart';
import 'package:mesa_bloc/app/models/modelProducto/product_data.dart';
part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
    List<ProductData> data;
    dynamic errors;
    List<Messages> messages;

    ProductModel ({
        required this.data,
        required this.errors,
        required this.messages,
    });

    factory ProductModel.fromJson(Map<String, dynamic> data) => _$ProductModelFromJson(data);
    Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}