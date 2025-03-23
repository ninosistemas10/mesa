import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/presentation/category/category_list.dart';
import 'package:mesa_bloc/app/presentation/product/product_screen.dart';
import 'package:mesa_bloc/app/utils/color.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedPage = 'Categoria';
  String? _categoryId;

  // Método para cambiar la pantalla
  void updatePage(String page, {String? categoryId}) {
    setState(() {
      _selectedPage = page;
      print('nino $categoryId');
      if (categoryId != null) {
        _categoryId = categoryId;
        print('nino $_categoryId');
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    print('holanino $_categoryId');
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _selectedPage == 'Categoria'
                      ? CategoryList(updatePage: updatePage) // Pasa la función a CategoryList
                      : ProductScreen(categoryId: _categoryId ?? "",),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
