
import 'package:flutter/material.dart';
import 'package:mesa_bloc/app/utils/app_colors.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_item.dart';
import 'package:mesa_bloc/app/utils/widgets/dropdown_string.dart';

class DropDownWidgetAdd<T> extends StatefulWidget {
  final String label;
  final List<T> list;
  final Function(T) onSelect;
  final double width;
  final double itemWidth;
  final bool error;

  const DropDownWidgetAdd({
    super.key,
    required this.label,
    required this.list,
    required this.onSelect,
    required this.width,
    this.error = false,
    required this.itemWidth,
  });

  @override
  State<DropDownWidgetAdd<T>> createState() => _DropDownWidgetAddState<T>();
}

class _DropDownWidgetAddState<T> extends State<DropDownWidgetAdd<T>> {
  T? selected;

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height * 2,
      ),
      items: widget.list.map((item) {
        String label = item is ItemDropdown ? item.label : (item as ItemDropdownString).label;
        return PopupMenuItem<T>(
          value: item,
          child: SizedBox(
            width: widget.itemWidth,
            child: Text(label, style: TextStyle(color: widget.error ? AppColor.primaryColor : AppColor.white)),
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        widget.onSelect(value);
        setState(() {
          selected = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (selected != null)
            Text(widget.label, style: TextStyle(color: widget.error ? AppColor.lead : AppColor.white)),
          const SizedBox(height: 5.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showMenu(context),
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: widget.error ? AppColor.primaryColor : AppColor.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected != null
                            ? (selected is ItemDropdown ? (selected as ItemDropdown).label : (selected as ItemDropdownString).label)
                            : widget.label,
                        style: TextStyle(color: selected != null ? AppColor.lead : AppColor.lead),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: widget.error ? AppColor.primaryColor : AppColor.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
