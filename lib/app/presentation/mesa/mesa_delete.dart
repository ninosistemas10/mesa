import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_bloc.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_state.dart';


class DeleteMesaDialog extends StatelessWidget {
  final String mesaId;

  const DeleteMesaDialog({super.key, required this.mesaId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MesaBloc, MesaState>(
      listenWhen: (previous, current) => previous.removed != current.removed,
      listener: (context, state) {
        if (state.removed) {
          print("✅ Mesa eliminada correctamente");

          // Mostrar Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mesa eliminada con éxito'),
              backgroundColor: Colors.green,
            ),
          );

          // Cerrar diálogo
          Navigator.pop(context);

          // Esperar un microtask antes de lanzar nuevos eventos
          Future.microtask(() {
            context.read<MesaBloc>().add(GetAllMesa());
          });
        }
      },
      child: BlocBuilder<MesaBloc, MesaState>(
        builder: (context, state) {
          return AlertDialog(
            title: const Text("Eliminar mesa"),
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
                        print("🛑 Eliminando Mesa con ID: $mesaId");
                        context.read<MesaBloc>().add(
                              RemoveMesa(mesaId: mesaId),
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
