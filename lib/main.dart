import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app.dart';
import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_bloc.dart';
import 'package:mesa_bloc/app/blocs/product/product_bloc.dart';
import 'package:mesa_bloc/app/blocs/promotion/promotion_bloc.dart';
import 'package:mesa_bloc/app/repositories/product/product_repository.dart';
import 'package:mesa_bloc/app/repositories/product/product_repository_impl.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (_) => ProductRepositoryImpl(),
        ),
      ],
      child: const MyAppWrapper(),
    ),
  );
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MesaBloc>( create: (_) => MesaBloc() ),
        BlocProvider<CategoryBloc>( create: (_) => CategoryBloc(), ),
        BlocProvider<ProductBloc>(  create: (_) => ProductBloc( repository: context.read<ProductRepository>())),
        BlocProvider<PromotionBloc>( create: (_) => PromotionBloc() )
      ],
      child: const MyApp(),
    );
  }
}