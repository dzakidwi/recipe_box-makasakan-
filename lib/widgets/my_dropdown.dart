// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyDropdown<T> extends StatefulWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final Color backgroundColor;
  final Color focusColor;
  final Color iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double height;
  final double elevation;
  final String Function(T)? itemLabel;

  const MyDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText = "Pilih opsi",
    this.backgroundColor = MyThemes.greyColor,
    this.focusColor = Colors.white,
    this.iconColor = Colors.black54,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.height = 48,
    this.elevation = 0,
    this.itemLabel,
  });

  @override
  State<MyDropdown<T>> createState() => _MyDropdownState<T>();
}

class _MyDropdownState<T> extends State<MyDropdown<T>> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isFocused ? widget.focusColor : widget.backgroundColor;

    return Focus(
      focusNode: _focusNode,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: widget.height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _isFocused
                ? MyThemes.primaryColor
                : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: MyThemes.primaryColor.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        padding: widget.padding,
        alignment: Alignment.center,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: widget.value,
            icon: Icon(Icons.keyboard_arrow_down, color: widget.iconColor),
            dropdownColor: Colors.white,
            style: MyThemes.titleMedium.copyWith(
              color: MyThemes.textColor,
              fontSize: 14,
            ),
            hint: Text(
              widget.hintText,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            items: widget.items.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(widget.itemLabel?.call(value) ?? value.toString()),
              );
            }).toList(),
            onChanged: (val) {
              widget.onChanged(val);
              FocusScope.of(context).unfocus(); // hilangkan fokus setelah pilih
            },
          ),
        ),
      ),
    );
  }
}
