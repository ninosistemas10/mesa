import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_state.dart';


class DeleteCategoryDialog extends StatelessWidget {
  final String categoryId;

  const DeleteCategoryDialog({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listenWhen: (previous, current) => previous.removed != current.removed,
      listener: (context, state) {
        if (state.removed) {
          print("✅ Categoría eliminada correctamente");

          // Mostrar Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría eliminada con éxito'),
              backgroundColor: Colors.green,
            ),
          );

          // Cerrar diálogo
          Navigator.pop(context);

          // Esperar un microtask antes de lanzar nuevos eventos
          Future.microtask(() {
            
            context.read<CategoryBloc>().add(GetAllCategory());
          });
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return AlertDialog(
            title: const Text("Eliminar categoría"),
            content: SizedBox(
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.loading)
                    const CircularProgressIndicator()
                  else
                    const Text("¿Confirmas la eliminación?"),
                  if (state.error.isNotEmpty)
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: state.loading ? null : () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: state.loading
                    ? null
                    : () {
                        print("🛑 Eliminando categoría con ID: $categoryId");
                        context.read<CategoryBloc>().add(
                              RemoveCategory(categoryId: categoryId),
                            );
                      },
                child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ),
    );
  }
}
