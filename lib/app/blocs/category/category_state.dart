import 'package:equatable/equatable.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';

enum ImageUpdateStatus { initial, loading, success, error }

class CategoryState extends Equatable {
  final bool loading;
  final String error;
  final bool add;
  final bool removed;
  final bool isUpdated;
  final List<CategoryData> listPromotion;
  final ImageUpdateStatus imageUpdateStatus;

  const CategoryState({
    this.loading = false,
    this.error = '',
    this.add = false,
    this.removed = false,
    this.isUpdated = false,
    this.listPromotion = const [],
    this.imageUpdateStatus = ImageUpdateStatus.initial,
  });

  CategoryState copyWith({
    bool? loading,
    String? error,
    bool? add,
    bool? removed,
    bool? isUpdated,
    List<CategoryData>? listCategory,
    ImageUpdateStatus? imageUpdateStatus,
  }) {
    return CategoryState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      add: add ?? this.add,
      removed:  removed ?? this.removed,
      isUpdated: isUpdated ?? this.isUpdated,
      listPromotion: listCategory ?? this.listPromotion,
      imageUpdateStatus: imageUpdateStatus ?? this.imageUpdateStatus,
    );
  }

  @override
  List<Object> get props => [loading, error, add, removed, isUpdated, listPromotion, imageUpdateStatus];
}