import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyFloatingActButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const MyFloatingActButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 28,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? MyThemes.primaryColor,
      tooltip: tooltip ?? 'Tambah',
      elevation: 4,
      shape: const CircleBorder(),
      child: Icon(
        icon,
        size: size,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}
