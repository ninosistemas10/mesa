part of 'promotion_bloc.dart';

abstract class PromotionEvent extends Equatable {
  const PromotionEvent();

  @override
  List<Object> get props => [];
}

class PromotionInit extends PromotionEvent {}

class GetAllPromotion extends PromotionEvent {}

class SavePromotion extends PromotionEvent {
  final PromocionData promotionData;
  const SavePromotion({required this.promotionData});
}

class UpdatedPromotionImage extends PromotionEvent {
  final String promotionId;
  final File? imageFile;
  final Uint8List? imageBytes;
  final String fileName;

  const UpdatedPromotionImage({
    required this.promotionId,
    this.imageFile,
    this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [promotionId, imageFile?.path ?? '', imageBytes ?? Uint8List(0), fileName];
}