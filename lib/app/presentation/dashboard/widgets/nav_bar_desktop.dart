import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/presentation/dashboard/widgets/notification_indicator.dart';
import 'package:mesa_bloc/app/presentation/dashboard/widgets/top_bar_avatar.dart';

class NavBarDesktop extends StatelessWidget {
  const NavBarDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      child: Row(
        children: [
          // Menú icon (si es necesario)
          const Spacer(),
          const NotificatorIndicator(),
          const SizedBox(width: 20),
          const TopBarAvatar(), // Widget corregido
        ],
      ),
    );
  }
}