
import 'dart:io';
import 'dart:typed_data';

import 'package:mesa_bloc/app/models/modelPromocion/promocion_data.dart';

abstract class PromotionRepository{
  Future<List<PromocionData>> getAllPromotion();

  Future<bool>savePromotion(PromocionData promotionData);

  Future<String> updatePromotionImage({ 
    required String promotionId, 
    required String fileName, 
    Uint8List? imageBytes, 
    File? imageFile 
  });

  Future<bool> updatePromotion(String promotionId, String nombre, String description, bool activo, {String? image});

  Future<bool> removePromotion(String promotionId);

}