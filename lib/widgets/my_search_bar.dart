import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MySearchBar extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Color backgroundColor;
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

  const MySearchBar({
    super.key,
    this.hintText = "Search any recipe",
    this.prefixIcon = Icons.search,
    this.backgroundColor = MyThemes.greyColor,
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
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        padding: padding,
        child: Row(
          children: [
            Icon(prefixIcon, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: autoFocus,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: MyThemes.titleMedium.copyWith(
                  color: MyThemes.textColor,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: hintStyle ??
                      TextStyle(
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
      ),
    );
  }
}
