import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/themes/my_themes.dart';

class MyBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const MyBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  // Function untuk dapat gradient sesuai menu aktif
  LinearGradient _getActiveGradient() {
    switch (selectedIndex) {
      case 0: // Kategori
        return MyThemes.secondaryGradient; // Hijau
      case 1: // Favorit
        return MyThemes.primaryGradient; // Merah
      case 2: // Tambah
        return MyThemes.accentGradient; // Kuning
      default:
        return MyThemes.primaryGradient;
    }
  }

  // Function untuk dapat warna aktif
  Color _getActiveColor() {
    switch (selectedIndex) {
      case 0: // Kategori
        return const Color.fromARGB(255, 0, 0, 0); // Hijau
      case 1: // Favorit
        return const Color.fromARGB(255, 0, 0, 0); // Merah
      case 2: // Tambah
        return const Color.fromARGB(255, 0, 0, 0); // Kuning
      default:
        return const Color.fromARGB(255, 0, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ConvexAppBar(
        backgroundColor: Colors.white,
        style: TabStyle.react,
        color: MyThemes.greyText,
        activeColor: _getActiveColor(), // Warna berubah sesuai menu aktif!
        items: const [
          TabItem(icon: Icons.category_rounded, title: 'Kategori'),
          TabItem(icon: Icons.favorite, title: 'Favorit'),
          TabItem(icon: Icons.add_rounded, title: 'Tambah'),
        ],
        initialActiveIndex: selectedIndex,
        onTap: onTabSelected,
        height: 60,
        curveSize: 100,
        top: -25,
        gradient: _getActiveGradient(), // Gradient berubah sesuai menu aktif!
      ),
    );
  }
}
