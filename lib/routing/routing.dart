import 'package:flutter/material.dart';
import 'package:recipe_box/screens/screen_favorite.dart';
import 'package:recipe_box/screens/screen_kategori_resep.dart';
import 'package:recipe_box/screens/screen_tambah_resep.dart';
import 'package:recipe_box/widgets/my_bottom_bar.dart';

class Routing extends StatefulWidget {
  final int? selectedIndex;
  const Routing({super.key, this.selectedIndex});

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  int? _selectedIndex; // POSISI DEFAULT TOMBOL TENGAH (FAVORITE)

  final List<Widget> _pages = [
    const ScreenKategoriResep(),
    const ScreenFavorite(),
    const ScreenTambahResep(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 1;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex!],
      bottomNavigationBar: MyBottomBar(
        selectedIndex: _selectedIndex!,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
