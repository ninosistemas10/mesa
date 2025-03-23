import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

class PortadaScreen extends StatelessWidget {
  const PortadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Bienvenida al señor\nTeodulo Nino Arango Tinco',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 40, // Padding derecho de 40
              top: -25,
              child: SvgPicture.asset(
                'assets/imagen/undraw_finance_m6vw.svg',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}