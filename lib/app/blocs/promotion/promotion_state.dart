part of 'promotion_bloc.dart';

enum ImageUpdatedStatus{ initial, loading, success, error}

class PromotionState extends Equatable {
  final bool loading;
  final String error;
  final bool add;
  final List<PromocionData> listPromotion;
  final ImageUpdatedStatus imageUpdatedStatus;
  final int refreshFlag;

  const PromotionState({
    this.loading = false, 
    this.error = '', 
    this.add = false,
    this.listPromotion = const [],
    this.imageUpdatedStatus = ImageUpdatedStatus.initial,
    this.refreshFlag = 0
  });

  PromotionState copyWith({
    bool? loading,
    String? error,
    bool? add,
    List<PromocionData>? listPromotion,
    ImageUpdatedStatus? imageUpdatedStatus,
    int? refreshFlag
  }) {
    return PromotionState(
      loading:        loading ?? this.loading,
      error:          error ?? this.error,
      add: add ?? this.add,
      listPromotion:  listPromotion ?? this.listPromotion,
      imageUpdatedStatus: imageUpdatedStatus ?? this.imageUpdatedStatus,
      refreshFlag: refreshFlag ?? DateTime.now().millisecondsSinceEpoch
    );
  }
  
  
  @override
  List<Object> get props => [loading, error, add, listPromotion, imageUpdatedStatus, refreshFlag];
}

final class PromotionInitial extends PromotionState {}
