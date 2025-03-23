import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_bloc.dart';
import 'package:mesa_bloc/app/blocs/category/category_state.dart';
import 'package:mesa_bloc/app/models/modelCategoria/category_data.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_item.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_widget%20_add.dart';
import 'package:mesa_bloc/app/utils/widgets/text_field.dart';

class CategoryAdd {
  static void show(BuildContext context) {
    final List<ItemDropdown> listStatus = [
      ItemDropdown(label: 'Activo', value: true),
      ItemDropdown(label: 'Inactivo', value: false)
    ];

    ItemDropdown? selectStatus;
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (builderContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColor.bgSideMenu,
          child: BlocProvider.value(
            value: BlocProvider.of<CategoryBloc>(context),
            child: BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state.add) { // 🔹 Cambio clave: Verifica el flag 'add'
                  Navigator.pop(context); // Cierra el diálogo
                  context.read<CategoryBloc>().add(CategoryInit()); // 🔹 Reinicia el estado
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Categoría agregada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  width: 400,
                  height: 500,
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
                            Text('Nueva Categoria',
                                style: TextStyle(color: AppColor.yellow)),
                            TextButton(
                              onPressed: () {
                                final String nombre = nombreController.text.trim();
                                final String descripcion = descriptionController.text.trim();
                                final bool estado = selectStatus?.value ?? true;

                                if (nombre.isEmpty || descripcion.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Todos los campos son obligatorios'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final categoryData = CategoryData(
                                  id: null,
                                  nombre: nombre,
                                  description: descripcion,
                                  images: '',
                                  activo: estado == 'Activo',
                                  createdAt: DateTime.now().millisecondsSinceEpoch,
                                  updatedAt: DateTime.now().millisecondsSinceEpoch,
                                );

                                context.read<CategoryBloc>().add(
                                  SaveCategory(categoryData: categoryData),
                                );
                              },
                              child: const Text('Grabar', style: TextStyle(color: Colors.green)),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        TextFieldWidget(
                          label: 'Nombre',
                          placeHolder: 'Nombre',
                          width: 300,
                          error: true,
                          controller: nombreController,
                          onChanged: (text) {},
                        ),
                        const SizedBox(height: 30),
                        TextFieldWidget(
                          label: 'Descripcion',
                          placeHolder: 'Descripcion',
                          width: 300,
                          error: true,
                          controller: descriptionController,
                          onChanged: (text) {},
                        ),
                        const SizedBox(height: 30),
                        DropDownWidgetAdd(
                          label: 'Estado',
                          list: listStatus,
                          onSelect: (select) => selectStatus = select,
                          width: 300,
                          itemWidth: 230,
                          error: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}