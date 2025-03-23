import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/promotion/promotion_bloc.dart';
import 'package:mesa_bloc/app/models/modelPromocion/promocion_data.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';
import 'package:mesa_bloc/app/utils/constants.dart';

class PromotionList extends StatefulWidget {
  final Function(String, {String? promotionId}) updatePage;

  const PromotionList({super.key, required this.updatePage});

  @override
  State<PromotionList> createState() => _PromotionListState();
}

class _PromotionListState extends State<PromotionList> {
  @override
  void initState() {
    context.read<PromotionBloc>().add(GetAllPromotion());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error.isNotEmpty) {
          return Center(child: Text(state.error));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // GridView para mostrar las promociones
              GridView.builder(
                shrinkWrap: true,  // Esto evita que el GridView ocupe todo el espacio disponible
                physics: NeverScrollableScrollPhysics(),  // Deshabilita el desplazamiento propio de GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,  // 4 Cards por fila
                  crossAxisSpacing: 10,  // Espacio horizontal entre Cards
                  mainAxisSpacing: 10,  // Espacio vertical entre Cards
                  childAspectRatio: 0.75,  // Proporción del tamaño de cada Card (ajusta según sea necesario)
                ),
                itemCount: state.listPromotion.length + 1,  // +1 por el icono de agregar
                itemBuilder: (context, index) {
                  if (index == state.listPromotion.length) {
                    // El último item es el contenedor con el icono de "Agregar"
                    return _buildAddPromotionButton();
                  } else {
                    return PromotionCard(
                      promotion: state.listPromotion[index],
                      updatePage: widget.updatePage,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddPromotionButton() {
    return GestureDetector(
      onTap: () {
        // Aquí puedes abrir una nueva pantalla o mostrar un cuadro de diálogo para agregar una nueva promoción
        // Ejemplo: widget.updatePage('AgregarPromocion');
        print("Agregar nueva promoción");
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bgSideMenu,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class PromotionCard extends StatelessWidget {
  final PromocionData promotion;
  final Function(String, {String? promotionId}) updatePage;

  const PromotionCard({super.key, required this.promotion, required this.updatePage});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: AppColor.bgSideMenu,
      child: Column(
        children: [
          // Parte superior con el nombre a la izquierda y los tres puntos a la derecha
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  promotion.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Aquí puedes manejar las acciones de editar o eliminar
                    if (value == 'edit') {
                      // Acción de editar
                      print('Editar promoción');
                      // Puedes hacer lo que quieras, como navegar a otra pantalla para editar
                    } else if (value == 'delete') {
                      // Acción de eliminar
                      print('Eliminar promoción');
                      // Aquí puedes agregar la lógica para eliminar la promoción
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Editar'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Eliminar'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          
          // Imagen de la promoción
          GestureDetector(
            onTap: () => _handleImageUpdate(context, promotion.id ?? ''),
            child: _buildPromotionImage(promotion.image),
          ),

          // Descripción de la promoción
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              promotion.description ?? 'Sin descripción',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Botón para ver más detalles
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.blue),
              onPressed: () => updatePage('Producto', promotionId: promotion.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionImage(String? imageUrl) {
    final fixedUrl = _fixImageUrl(imageUrl);
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho del card
      height: 150, // Puedes ajustar la altura según lo que necesites
      child: fixedUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: fixedUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, __, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: AppColor.primaryColor,
                ),
              ),
              errorWidget: (_, __, ___) => _buildImagePlaceholder(),
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 28,
        ),
      ),
    );
  }

  String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.contains("localhost")) {
      return url.replaceAll("localhost", Constants.localhost);
    }
    if (!url.startsWith("http")) {
      return "http://${Constants.localhost}:8081/$url";
    }
    return url;
  }

  Future<void> _handleImageUpdate(BuildContext context, String promotionId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.bytes == null) return;

      if (!context.mounted) return;

      context.read<PromotionBloc>().add(
        UpdatedPromotionImage(
          promotionId: promotionId,
          imageBytes: file.bytes!,
          fileName: file.name,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Imagen actualizada exitosamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar la imagen"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
