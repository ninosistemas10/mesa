import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/presentation/product/product_screen.dart';
import 'package:mesa_bloc/app/presentation/promotion/promotion_list.dart';
import 'package:mesa_bloc/app/utils/color.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  String _selectedPage = 'Promocion';
  String? _promotionId;

  // Método para cambiar la pantalla
  void updatePage(String page, {String? promotionId}) {
    setState(() {
      _selectedPage = page;
      print('nino $promotionId');
      if (promotionId != null) {
        _promotionId = promotionId;
        print('nino $_promotionId');
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    print('holanino $_promotionId');
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
                  child: _selectedPage == 'Promocion'
                      ? PromotionList(updatePage: updatePage) // Pasa la función a CategoryList
                      : ProductScreen(categoryId: _promotionId ?? "",),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
