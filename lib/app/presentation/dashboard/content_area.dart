import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/menu/menu_bloc.dart';
import 'package:mesa_bloc/app/blocs/promotion/promotion_bloc.dart';
import 'package:mesa_bloc/app/presentation/category/category_screen.dart';
import 'package:mesa_bloc/app/presentation/mesa/mesa_screen.dart';
import 'package:mesa_bloc/app/presentation/product/product_screen.dart';
import 'package:mesa_bloc/app/presentation/promotion/promotion_screen.dart';
import 'package:mesa_bloc/app/presentation/venta/venta_screen.dart';

class ContentArea extends StatelessWidget {
  const ContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => PromotionBloc(),
          child:  _buildScreenByMenuState(state),
        );
        
      },
    );
  }

  Widget _buildScreenByMenuState(MenuState state) {
    switch (state.selectedPage) {
          case 'Ventas':
            return VentaScreen();
          case 'Dashboard':
            return const MesaScreen();
          case 'Categoria':
            return const CategoryScreen();
          case 'Mesa':
            return const MesaScreen();
          case 'Promocion':
            return const PromotionScreen();
          case 'Producto':
            return ProductScreen(
              
              categoryId: state.selectedCategoryId ?? '',
              categoryName: state.selectedCategoryname ?? '',
               // Cambio crucial aquí
            );
          default:
            return const Center(child: Text('Página no encontrada'));
        }
      }
}