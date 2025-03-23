import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

class MesaCard extends StatelessWidget {
  final MesaData mesa;

  const MesaCard({super.key, required this.mesa});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 22, 18, 18), // Fondo gris oscuro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildImage(mesa.images),
          const SizedBox(height: 8),
          Text(
            mesa.nombre,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Texto blanco
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgSideMenu, // Fondo gris para el área de la imagen
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? SvgPicture.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholderBuilder: (context) => Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey[600],
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          : SvgPicture.asset(
              'assets/imagen/grupo.svg',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              color: Colors.white, // Color blanco para el icono
            ),
    );
  }
}