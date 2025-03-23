

import 'package:json_annotation/json_annotation.dart';
import 'package:mesa_bloc/app/models/modelMesa/message.dart';
import 'package:mesa_bloc/app/models/modelPromocion/promocion_data.dart';

part 'model_promocion.g.dart';

@JsonSerializable(explicitToJson: true)
class ModelPromocion {
    List<PromocionData> data;
    String? errors;
    List<Messages> messages;

    ModelPromocion({ 
        required this.data, 
        this.errors, 
        required this.messages,
    });

    factory ModelPromocion.fromJson(Map<String, dynamic> data) => _$ModelPromocionFromJson(data);

    //set images(String images) {}

    Map<String, dynamic> toJson() => _$ModelPromocionToJson(this);
}


