// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyTextfield extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final Color backgroundColor;
  final Color focusColor;
  final Color iconColor;
  final double borderRadius;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry padding;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final bool autoFocus;
  final double height;
  final double elevation;

  const MyTextfield({
    super.key,
    this.hintText = "Tulis sesuatu...",
    this.prefixIcon,
    this.backgroundColor = MyThemes.greyColor,
    this.focusColor = Colors.white,
    this.iconColor = Colors.black54,
    this.borderRadius = 20,
    this.hintStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autoFocus = false,
    this.height = 48,
    this.elevation = 0,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: MyThemes.primaryColor.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
        border: Border.all(
          color: _isFocused
              ? MyThemes.primaryColor
              : Colors.transparent,
          width: 1.2,
        ),
      ),
      alignment: Alignment.center,
      padding: widget.padding,
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            Icon(widget.prefixIcon, color: widget.iconColor),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              autofocus: widget.autoFocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: MyThemes.titleMedium.copyWith(
                color: MyThemes.textColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
