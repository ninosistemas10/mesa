import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String placeHolder;
  final IconData? icon;
  final bool isTextArea;
  final double width;
  final TextEditingController controller;
  final bool error;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final bool isDecimal;  // Nuevo parámetro para decimales
  final bool isInteger;  // Nuevo parámetro para enteros

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.placeHolder,
    this.icon,
    this.isTextArea = false,
    required this.width,
    required this.controller,
    this.error = false,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isDecimal = false,
    this.isInteger = false,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool isTextFieldActive = false;
  late List<TextInputFormatter> inputFormatters;

  @override
  void initState() {
    super.initState();
    
    // Configurar formateadores según el tipo de campo
    inputFormatters = [];
    if (widget.isDecimal) {
      inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')));
    } else if (widget.isInteger) {
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.controller.text.isNotEmpty) {
      isTextFieldActive = true;
    }
    widget.controller.addListener(updateTextFieldState);
  }

  void updateTextFieldState() {
    setState(() {
      isTextFieldActive = widget.controller.text.isNotEmpty;
      widget.onChanged(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: isTextFieldActive 
                ? const EdgeInsets.only(bottom: 5.0) 
                : EdgeInsets.zero,
            child: isTextFieldActive
                ? Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.error 
                          ? AppColor.lead 
                          : Colors.grey[100]
                    ),
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.error 
                    ? AppColor.primaryColor 
                    : AppColor.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              cursorColor: AppColor.white,
              controller: widget.controller,
              maxLines: widget.isTextArea ? 6 : 1,
              keyboardType: _getKeyboardType(),
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: isTextFieldActive ? '' : widget.label,
                suffixIcon: _buildSuffixIcon(),
                hintStyle: TextStyle(color: AppColor.lead),
              ),
              style: TextStyle(
                color: widget.error 
                    ? AppColor.lead 
                    : AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType() {
    if (widget.isDecimal) return TextInputType.numberWithOptions(decimal: true);
    if (widget.isInteger) return TextInputType.number;
    return widget.keyboardType;
  }

  Widget? _buildSuffixIcon() {
    if (widget.icon != null) {
      return Icon(
        widget.icon, 
        color: widget.error ? AppColor.yellow : AppColor.yellow
      );
    }
    if (widget.isDecimal) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text('€', style: TextStyle(
          color: AppColor.white,
          fontSize: 16
        )),
      );
    }
    return null;
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateTextFieldState);
    super.dispose();
  }
}