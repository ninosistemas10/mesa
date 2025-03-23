import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/presentation/product/product_list.dart';
import 'package:mesa_bloc/app/utils/color.dart';

class ProductScreen extends StatelessWidget {
  final String categoryId;
  final String? categoryName;
  const ProductScreen({super.key, required this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context) {
    print('ninito $categoryId');
    print('ninito $categoryName');

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      
                      ProductList(categoryId: categoryId, categoryName: categoryName,),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}