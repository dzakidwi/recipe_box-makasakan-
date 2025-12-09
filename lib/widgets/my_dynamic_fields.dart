import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyDynamicField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;

  const MyDynamicField({
    super.key,
    required this.index,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: MyThemes.greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${index + 1}. ",
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Focus(
              onFocusChange: (focused) {},
              child: TextFormField(
                controller: controller,
                autofocus: autoFocus,
                onChanged: onChanged,
                style: MyThemes.titleMedium.copyWith(
                  color: MyThemes.textColor,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                validator: (v) => v!.isEmpty ? "Isi data ini" : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
