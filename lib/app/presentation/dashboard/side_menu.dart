import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesa_bloc/app/blocs/menu/menu_bloc.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: screenWidth > 1800 ? 270 : screenWidth < 1140 ? 220 : 270,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bgSideMenu,
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  _buildMenuItems(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/imagen/cafe-logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DRINK', style: TextStyle(color: AppColor.orange, fontSize: 16)),
                Text('THINK', style: TextStyle(color: AppColor.orange, fontSize: 16)),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(color: Colors.white54, height: 1),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(context, 'Ventas', Icons.dashboard),
        _buildMenuItem(context, 'Categoria', Icons.table_bar),
        _buildMenuItem(context, 'Promocion', Icons.production_quantity_limits_rounded),
        _buildMenuItem(context, 'Mesa', Icons.local_offer),
        _buildMenuItem(context, 'Producto', Icons.category),
        _buildMenuItem(context, 'Usuario', Icons.people),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        final isSelected = state.selectedPage == title;
        final isHovered = state.hoveredItems[title] ?? false;

        return MouseRegion(
          onEnter: (_) => _onHover(context, title, true),
          onExit: (_) => _onHover(context, title, false),
          child: InkWell(
            onTap: () => context.read<MenuBloc>().add(SelectMenuEvent(page: title)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.orange
                          : isHovered
                              ? AppColor.orange.withOpacity(0.2)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? AppColor.bgSideMenu
                          : isHovered
                              ? AppColor.orange
                              : Colors.white54,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isSelected
                            ? AppColor.orange
                            : isHovered
                                ? AppColor.white
                                : Colors.white54,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onHover(BuildContext context, String title, bool hovering) {
    // Enviar evento de hover al Bloc
    context.read<MenuBloc>().add(HoverMenuEvent(page: title, isHovering: hovering));
  }
}
