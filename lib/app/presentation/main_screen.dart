import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/menu/menu_bloc.dart';
import 'package:mesa_bloc/app/presentation/dashboard/content_area.dart';
import 'package:mesa_bloc/app/presentation/dashboard/side_menu.dart';
import 'package:mesa_bloc/app/presentation/dashboard/widgets/nav_bar_desktop.dart';
import 'package:mesa_bloc/app/utils/color.dart';
import 'package:mesa_bloc/app/utils/widgets/portada_screen.dart';

class MainScreen extends StatelessWidget {
  static String routeName = '/main';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Row(
            children: [
              const SideMenu(), // Eliminamos los parámetros antiguos
              Expanded(
                child: Column(
                  children: [
                    const NavBarDesktop(),
                    const SizedBox(height: 40),
                    const PortadaScreen(),
                    Expanded(
                      child: BlocBuilder<MenuBloc, MenuState>(
                        builder: (context, state) {
                          return ContentArea(
                        
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}