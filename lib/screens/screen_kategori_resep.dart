import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:recipe_box/models/kategori_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';
import 'package:recipe_box/screens/screen_form_tambah_kategori.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/animated_widgets.dart' as custom;
import 'package:recipe_box/screens/screen_detail_kategori.dart';

class ScreenKategoriResep extends StatefulWidget {
  const ScreenKategoriResep({super.key});

  @override
  State<ScreenKategoriResep> createState() => _ScreenKategoriResepState();
}

class _ScreenKategoriResepState extends State<ScreenKategoriResep> {
  final TextEditingController _searchController = TextEditingController();
  List<KategoriResep> kategoriList = [];
  List<KategoriResep> kategoriFiltered = [];

  // AUTO-HIDE FAB
  bool _showFAB = true;
  Timer? _hideTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadKategori();
    _searchController.addListener(_runFilter);
    _startHideTimer();
    _scrollController.addListener(_onUserInteraction);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    setState(() => _showFAB = true);

    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showFAB = false);
      }
    });
  }

  void _onUserInteraction() {
    _hideTimer?.cancel();
    if (!_showFAB) {
      setState(() => _showFAB = true);
    }
    _startHideTimer();
  }

  Future<void> _loadKategori() async {
    final data = await KategoriRepository().getAllKategori();
    setState(() {
      kategoriList = data;
      kategoriFiltered = data;
    });
  }

  void _runFilter() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      kategoriFiltered = kategoriList.where((kategori) {
        return kategori.namaKategori.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _hapusKategori(int? id) async {
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Text("Gagal menghapus kategori"),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
      return;
    }

    await KategoriRepository().deleteKategori(id);
    await _loadKategori();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("Kategori berhasil dihapus"),
          ],
        ),
        backgroundColor: MyThemes.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onUserInteraction,
      onPanDown: (_) => _onUserInteraction(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [MyThemes.secondaryColor.withOpacity(0.1), Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // MODERN HEADER
                GestureDetector(
                  onTap: _onUserInteraction,
                  child: _buildModernHeader(),
                ),

                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _onUserInteraction,
                    child: custom.FadeInAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: _buildModernSearchBar(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LIST KATEGORI
                Expanded(
                  child: kategoriFiltered.isEmpty
                      ? _buildEmptyState()
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            _onUserInteraction();
                            return false;
                          },
                          child: AnimationLimiter(
                            child: GridView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.70,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                              itemCount: kategoriFiltered.length,
                              itemBuilder: (context, index) {
                                final kategori = kategoriFiltered[index];

                                return GestureDetector(
                                  onTap: () {
                                    _onUserInteraction();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenDetailKategori(
                                              kategori: kategori,
                                            ),
                                      ),
                                    );
                                  },
                                  child: AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 600),
                                    columnCount: 2,
                                    child: custom.ScaleAnimation(
                                      child: custom.FadeInAnimation(
                                        child: _buildKategoriCard(kategori),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          offset: _showFAB ? Offset.zero : const Offset(0, 3),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            opacity: _showFAB ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: custom.ScaleAnimation(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: MyThemes.secondaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyThemes.secondaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      _onUserInteraction();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const ScreenFormTambahKategori(),
                      ).then((_) {
                        _loadKategori();
                        _onUserInteraction();
                      });
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: const Icon(Icons.add, size: 32),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return custom.FadeInAnimation(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: MyThemes.secondaryGradient,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: MyThemes.secondaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.category,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategori Resep',
                        style: MyThemes.titleLarge.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola kategori resep kamu! 📁',
                        style: MyThemes.subtitle.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onTap: _onUserInteraction,
        decoration: InputDecoration(
          hintText: 'Cari kategori',
          hintStyle: TextStyle(color: MyThemes.greyText.withOpacity(0.6)),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: MyThemes.secondaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildKategoriCard(KategoriResep kategori) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child:
                      (kategori.fotoPath != null &&
                          File(kategori.fotoPath!).existsSync())
                      ? Image.file(File(kategori.fotoPath!), fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(
                            gradient: MyThemes.coolGradient,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.fastfood,
                              size: 50,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                ),
              ),

              // DELETE BUTTON
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      _onUserInteraction();
                      _showDeleteDialog(kategori);
                    },
                  ),
                ),
              ),
            ],
          ),

          // NAMA KATEGORI
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori.namaKategori,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: MyThemes.accentGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kategori',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(KategoriResep kategori) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text("Hapus Kategori", style: TextStyle(fontSize: 20)),
          ],
        ),
        content: Text(
          "Yakin ingin menghapus kategori '${kategori.namaKategori}'?",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _hapusKategori(kategori.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: custom.FadeInAnimation(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: MyThemes.secondaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MyThemes.secondaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.category, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 25),
            const Text(
              'Belum Ada Kategori',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tambahkan kategori untuk\nmengorganisir resep kamu! 📁',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: MyThemes.greyText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
