import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color backgroundColor;
  final double height;
  final double borderRadius;
  final bool showBackButton;
  final Alignment titleAlignment;
  final Widget? actionWidget;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  const MyAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor = MyThemes.backgroundColor,
    this.height = 10,
    this.borderRadius = 25,
    this.showBackButton = false,
    this.titleAlignment = Alignment.centerLeft,
    this.actionWidget,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(borderRadius),
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: padding,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // POSISI TEKS FLEKSIBEL (KIRI, TENGAH, KANAN)
              Align(
                alignment: titleAlignment,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: titleStyle ??
                              MyThemes.titleLarge.copyWith(
                                color: MyThemes.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: subtitleStyle ??
                                MyThemes.titleMedium.copyWith(
                                  color: MyThemes.primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // WIDGET AKSI KANAN (ICON, TOMBOL, AVATAR, DSB)
              if (actionWidget != null)
                Positioned(
                  right: 10,
                  child: actionWidget!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
