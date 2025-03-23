import 'package:equatable/equatable.dart';
import 'package:mesa_bloc/app/models/modelProducto/product_data.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductData> products;
  ProductLoaded(this.products);
  
  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
  
  @override
  List<Object?> get props => [message];
}
