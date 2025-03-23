import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

class TopBarAvatar extends StatelessWidget {
  const TopBarAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            //color: AppColor.blueLight,
            width: 35,
            height: 35,
            child: Image.asset(
              'assets/imagen/male.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nino',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.bgSideMenu
              ),
            ),
            Text(
              'admin',
              style: TextStyle(
                fontSize: 12,
                color: AppColor.bggsideMenu
              ),
            ),
          ],
        ),
        const SizedBox(width: 5),
        PopupMenuButton<String>(
          offset: const Offset(0, 40),
          color: AppColor.bgSideMenu,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 24),
          onSelected: (value) {
            if (value == 'usuario') print("Perfil de usuario");
            else if (value == 'salir') print("Cerrando sesión...");
          },
          itemBuilder: (BuildContext context) => [
            _buildMenuItem('usuario', 'Usuario'),
            _buildMenuItem('salir', 'Salir sesión'),
          ],
        )
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: _HoverableText(text: text),
    );
  }
}

class _HoverableText extends StatefulWidget {
  final String text;

  const _HoverableText({required this.text});

  @override
  State<_HoverableText> createState() => _HoverableTextState();
}

class _HoverableTextState extends State<_HoverableText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isHovered ? AppColor.orange : AppColor.green,
            fontSize: _isHovered ? 16 :14,
          ),
        ),
      ),
    );
  }
}