import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/promotion/promotion_bloc.dart';
import 'package:mesa_bloc/app/models/modelPromocion/promocion_data.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_item.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_string.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_widget%20_add.dart';
import 'package:mesa_bloc/app/utils/widgets/text_field.dart';

class PromotionAdd {
  static void show(BuildContext context) {
    final List<ItemDropdown> listStatus = [
      ItemDropdown(label: 'Activo', value: true),
      ItemDropdown(label: 'Inactivo', value: false)
    ];

    // Nuevos campos requeridos
    final List<ItemDropdownString> listCategories = [
      ItemDropdownString(label: 'Comidas', value: 'Comidas'),
      ItemDropdownString(label: 'Bebidas', value: 'Bebiudas'),
      ItemDropdownString(label: 'Combos', value: 'Combos'),
    ];

    ItemDropdown? selectStatus;
    ItemDropdownString? selectdCategory;
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController precioController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    final Map<String, dynamic> features = {};

    showDialog(
      context: context, 
      builder: (builderContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          backgroundColor: AppColor.bgSideMenu,
          child: BlocProvider.value(
            value: BlocProvider.of<PromotionBloc>(context),
            child: BlocConsumer<PromotionBloc, PromotionState>(
              listener: (context, state) {
                if (state.add) {
                  Navigator.pop(context);
                  context.read<PromotionBloc>().add(PromotionInit());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Promoción agregada exitosamente'),
                      backgroundColor: AppColor.green,
                    )
                  );
                }
              }, 
              builder: (BuildContext context, state) {
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 400,
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.arrow_back, color: AppColor.white),
                              ),
                              Text('Nueva Promoción',
                                  style: TextStyle(color: AppColor.yellow)),
                              TextButton(
                                onPressed: () {
                                  final String nombre = nombreController.text.trim();
                                  final String descripcion = descriptionController.text.trim();
                                  final bool estado = selectStatus?.value ?? true;
                                  final String? categoria = selectdCategory?.value;
                                  
                                  double precio = 0.0;
                                  int stock = 0;

                                  try {
                                    precio = double.parse(precioController.text.trim());
                                    stock = int.parse(stockController.text.trim());
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Valores numéricos inválidos'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (nombre.isEmpty || descripcion.isEmpty ) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Todos los campos obligatorios deben ser llenados'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (categoria == null || categoria.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Debe seleccionar una categoría'),
      backgroundColor: Colors.red,
    ),
  );
  return; // 🔴 Evita enviar datos incorrectos
}
print('Datos a enviar:');
print('Nombre: $nombre');
print('Descripción: $descripcion');
print('Precio: $precio');
print('Categoría: $categoria');
print('Stock: $stock');
print('Estado: $estado');
print('Features: $features');

                                  final promotionData = PromocionData(
                                    nombre: nombre,
                                    description: descripcion,
                                    precio: precio,
                                    categoria: categoria,
                                    stockDisponible: stock.toInt(),
                                    activo: estado,
                                    features: features,
                                    createdAt: DateTime.now().millisecondsSinceEpoch,
                                    updatedAt: DateTime.now().millisecondsSinceEpoch,
                                  );

                                  context.read<PromotionBloc>().add(
                                    SavePromotion(promotionData: promotionData),
                                  );
                                },
                                child: const Text('Grabar', style: TextStyle(color: Colors.green)),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Campos principales
                          Column(
                            children: [
                              TextFieldWidget(
                                label: 'Nombre*',
                                placeHolder: 'Nombre de la promoción',
                                width: 300,
                                controller: nombreController,
                                keyboardType: TextInputType.text,
                                onChanged: (_) {},
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget(
                                label: 'Descripción*',
                                placeHolder: 'Descripción detallada',
                                width: 300,
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                onChanged: (_) {},
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget(
                                label: 'Precio*',
                                placeHolder: '0.00',
                                width: 300,
                                isDecimal: true,
                                controller: precioController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget(
                                label: 'Stock Disponible*',
                                placeHolder: 'Cantidad en inventario',
                                width: 300,
                                isInteger: true,
                                controller: stockController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 15),
                              
                              const SizedBox(height: 15),
                              DropDownWidgetAdd(
                                label: 'Categoría*',
                                list: listCategories,
                                onSelect: (select) => selectdCategory = select ,
                                width: 300,
                                itemWidth: 230,
                              ),
                              const SizedBox(height: 15),
                              DropDownWidgetAdd(
                                label: 'Estado*',
                                list: listStatus,
                                onSelect: (select) => selectStatus = select,
                                width: 300,
                                itemWidth: 230,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }
}