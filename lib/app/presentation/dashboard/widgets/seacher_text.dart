
import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/presentation/dashboard/widgets/custom_input.dart';


class SeacherText extends StatelessWidget {
    const SeacherText({super.key});

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 40,
            decoration: buildBoxDecoration(),
            child: TextField(
                decoration: CustomInputs.searchInputDecoration(
                    hint: 'Buscar', 
                    icon: Icons.search_outlined
                )
            ),
        );
    }

    BoxDecoration buildBoxDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.grey.withValues()
  );
}