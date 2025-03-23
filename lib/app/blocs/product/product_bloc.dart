import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_event.dart';
import 'package:mesa_bloc/app/blocs/product/product_state.dart';
import 'package:mesa_bloc/app/repositories/product/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadProductsByCategory(
      LoadProductsByCategory event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProductsByCategory(event.categoryId);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Error al cargar productos: $e'));
    }
  }
}
