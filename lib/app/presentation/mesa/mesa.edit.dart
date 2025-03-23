import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_bloc.dart';
import 'package:mesa_bloc/app/blocs/mesa/mesa_state.dart';

import 'package:mesa_bloc/app/models/modelMesa/mesa_data.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_item.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_widget_edit.dart';
import 'package:mesa_bloc/app/utils/widgets/text_field.dart';


class EditMesaDialog extends StatefulWidget {
  final MesaData mesa;

  const EditMesaDialog({super.key, required this.mesa});

  @override
  _EditMesaDialogState createState() => _EditMesaDialogState();
}

class _EditMesaDialogState extends State<EditMesaDialog> {
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  bool _isActive = false;

  final List<ItemDropdown> listStatus = [
    ItemDropdown(label: 'Activo', value: true),
    ItemDropdown(label: 'Inactivo', value: false),
  ];
  ItemDropdown? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.mesa.nombre);
    _urlController = TextEditingController(text: widget.mesa.url);
    _isActive = widget.mesa.activo;
    _selectedStatus = _isActive ? listStatus[0] : listStatus[1];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MesaBloc, MesaState>(
  listenWhen: (previous, current) => previous.updated != current.updated,
  listener: (context, state) {
    if (state.updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mesa actualizada con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // 🔹 Asegura que el diálogo se cierre
    }
  },
  child: Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: AppColor.bgSideMenu,
    child: Container(
      padding: const EdgeInsets.all(20),
      width: 400,
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Text(
                'Editar Mesa',
                style: TextStyle(color: AppColor.yellow, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  context.read<MesaBloc>().add(
                    UpdatedMesa(
                      mesaId: widget.mesa.id!,
                      nombre: _nameController.text,
                      url: _urlController.text, 
                      activo: _selectedStatus!.value
                    )
                  );
                },
                child: const Text('Actualizar', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: 'Nombre',
            placeHolder: 'Nombre',
            width: 300,
            controller: _nameController,
            error: true,
            onChanged: (text) {},
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: 'Descripción',
            placeHolder: 'Descripción',
            width: 300,
            controller: _urlController,
            error: true,
            onChanged: (text) {},
          ),
          const SizedBox(height: 30),
          DropDownWidgetEdit(
            label: 'Estado',
            list: listStatus,
            onSelect: (selected) => setState(() => _selectedStatus = selected),
            defaultValue: _selectedStatus!.label,
            whidt: 300,
            itemWidth: 230,
            error: true,
          ),
        ],
      ),
    ),
  ),
    );
  }
}
