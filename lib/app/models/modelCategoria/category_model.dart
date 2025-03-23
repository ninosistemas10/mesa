
import 'package:json_annotation/json_annotation.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_message.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {
    List<CategoryData> data;
    String? errors;
    List<Messages> messages;

    

    CategoryModel({ 
        required this.data, 
        this.errors, 
        required this.messages,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> data) => _$CategoryModelFromJson(data);

  set images(String images) {}

    Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}


