
import 'package:json_annotation/json_annotation.dart';
import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';
import 'package:mesa_bloc/app/models/modelMesa/message.dart';
part 'model_mesa.g.dart';

@JsonSerializable(explicitToJson: true)

class ModelMesa{
    List<MesaData> data;
    dynamic errors;
    List<Messages> messages;

    ModelMesa({
        required this.data,
        required this.errors,
        required this.messages,
    });

    factory ModelMesa.fromJson(Map<String, dynamic> data) => _$ModelMesaFromJson(data);
    Map<String, dynamic> toJson() => _$ModelMesaToJson(this);
}