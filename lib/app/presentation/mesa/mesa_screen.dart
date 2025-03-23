import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_bloc.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_state.dart';
import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';
import 'package:mesa_bloc/app/presentation/mesa/mesa.edit.dart';
import 'package:mesa_bloc/app/presentation/mesa/mesa_add.dart';
import 'package:mesa_bloc/app/presentation/mesa/mesa_delete.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

class MesaScreen extends StatefulWidget {
  const MesaScreen({super.key});

  @override
  _MesaScreenState createState() => _MesaScreenState();
}

class _MesaScreenState extends State<MesaScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MesaBloc>().add(GetAllMesa());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MesaBloc, MesaState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(child: Text(state.error));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0, // 🔹 Hace que las tarjetas sean cuadradas
            ),
            itemCount: state.listMesa.length + 1,
            itemBuilder: (context, index) {
              if (index == state.listMesa.length) {
                return _AddMesaCard();
              }
              return MesaCard(mesa: state.listMesa[index]);
            },
          );
        },
      ),
    );
  }
}

class _AddMesaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 🔹 Cambia el cursor a una "manito"
      child: GestureDetector(
        onTap: () => MesaAdd.show(context),
        child: Card(
          color: AppColor.bgSideMenu,
          child: Center(
            child: Icon(
              Icons.add,
              size: 40,
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class MesaCard extends StatelessWidget { 
  final MesaData mesa;

  const MesaCard({super.key, required this.mesa});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300], // 🔹 Fondo gris para la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        children: [
          // 🔹 Área superior con nombre y menú (fondo blanco)
          Container(
            height: 50, // 🔹 Altura fija para el área de texto
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColor.bgSideMenu,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mesa.nombre,
                    style: TextStyle(
                      color: AppColor.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _MenuButton(mesa: mesa),
              ],
            ),
          ),

          // 🔹 Imagen que ocupa todo el espacio restante sin ser recortada
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Container(
                color: Colors.grey[200],
                width: double.infinity, // 🔹 Asegura que la imagen ocupe todo el ancho
                child: SvgPicture.asset(
                  'assets/imagen/grupo.svg',
                  fit: BoxFit.contain, // 🔹 Ajusta la imagen sin recortar
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final MesaData mesa;

  const _MenuButton({required this.mesa});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, size: 20, color: AppColor.primaryColor),
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue, size: 18),
              SizedBox(width: 8),
              Text('Editar', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text('Eliminar', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          _editarMesa(context, mesa);
        } else if (value == 2) {
          _eliminarMesa(context, mesa);
        }
      },
    );
  }

  void _editarMesa(BuildContext context, MesaData mesa) {
    print(mesa.nombre);
    showDialog(
      context: context,
      builder: (context) => EditMesaDialog(mesa: mesa)
      
    );
  }

  void _eliminarMesa(BuildContext context, MesaData mesa) {
    showDialog(
      context: context,
      builder: (context) => DeleteMesaDialog(mesaId: mesa.id ?? '')
    );
  }
}
