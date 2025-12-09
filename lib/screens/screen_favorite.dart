// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';
import 'package:recipe_box/repository/resep_bahan_repository.dart';
import 'package:recipe_box/repository/resep_langkah_repository.dart';
import 'package:recipe_box/repository/resep_repository.dart';
import 'package:recipe_box/screens/screen_detail_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/animated_widgets.dart' as custom;

class ScreenFavorite extends StatefulWidget {
  const ScreenFavorite({super.key});

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
  final _resepRepo = ResepRepository();
  final _kategoriRepo = KategoriRepository();
  final _resepBahanRepo = ResepBahanRepository();
  final _resepLangkahRepo = ResepLangkahRepository();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [MyThemes.primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // MODERN HEADER
              _buildModernHeader(),

              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: custom.FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: _buildModernSearchBar(),
                ),
              ),

              const SizedBox(height: 20),

              // LIST RESEP
              Expanded(
                child: FutureBuilder<List<Resep>>(
                  future: _resepRepo.getAllResep(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _buildShimmerLoading();
                    }

                    final resepList = snapshot.data!;
                    final favoriteResepList = resepList
                        .where((r) => r.isFavorite == true)
                        .toList();
                    final filtered = favoriteResepList.where((r) {
                      final judul = r.judul.toLowerCase();
                      return judul.contains(searchQuery);
                    }).toList();

                    if (filtered.isEmpty) {
                      return _buildEmptyState();
                    }

                    final futures = filtered.map((r) async {
                      final nama = await _kategoriRepo.getNamaById(
                        r.kategoriId,
                      );
                      return {'resep': r, 'kategoriNama': nama};
                    }).toList();

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: Future.wait(futures),
                      builder: (context, snapshot2) {
                        if (!snapshot2.hasData) {
                          return _buildShimmerLoading();
                        }

                        final data = snapshot2.data!;

                        return AnimationLimiter(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final resep = data[index]['resep'] as Resep;
                              final kategoriNama =
                                  data[index]['kategoriNama'] as String;

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 600),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: custom.FadeInAnimation(
                                    child: _buildModernResepCard(
                                      resepId: resep.id!,
                                      judul: resep.judul,
                                      kategori: kategoriNama,
                                      imagePath: resep.imagePath,
                                      isFavorite: resep.isFavorite,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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
                    gradient: MyThemes.primaryGradient,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: MyThemes.primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
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
                        'Resep Favorit',
                        style: MyThemes.titleLarge.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kumpulan resep terbaik kamu! 🍳',
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
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari resep favorit...',
          hintStyle: TextStyle(color: MyThemes.greyText.withOpacity(0.6)),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: MyThemes.primaryGradient,
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

  Widget _buildModernResepCard({
    required int resepId,
    required String judul,
    required String kategori,
    required String? imagePath,
    required bool isFavorite,
  }) {
    return custom.BounceAnimation(
      onTap: () async {
        final resep = await _resepRepo.getResepById(resepId);
        if (resep == null) return;
        final kategoriNama = await _kategoriRepo.getNamaById(resep.kategoriId);
        final bahanList = await _resepBahanRepo.getBahanByResep(resepId);
        final langkahList = await _resepLangkahRepo.getLangkahByResep(resepId);
        final bahanStrings = bahanList.map((b) => b.bahan).toList();
        final langkahStrings = langkahList.map((l) => l.langkah).toList();

        final dtoResep = FormResepDTO(
          id: resep.id,
          judul: judul,
          kategoriId: resep.kategoriId,
          kategoriNama: kategoriNama,
          porsi: resep.porsi,
          waktuMasak: resep.waktuMasak,
          bahan: bahanStrings,
          langkah: langkahStrings,
          imagePath: resep.imagePath,
        );

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: ScreenDetailResep(resep: dtoResep),
            duration: const Duration(milliseconds: 300),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
            // FOTO RESEP dengan Hero Animation
            Stack(
              children: [
                Hero(
                  tag: 'resep_$resepId',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    child: imagePath == null || imagePath.isEmpty
                        ? Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: MyThemes.coolGradient,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.restaurant,
                                size: 60,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          )
                        : Image.file(
                            File(imagePath),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                // Gradient Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Kategori Badge
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      kategori,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MyThemes.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: MyThemes.accentGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Favorit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
                  // FAVORITE BUTTON
                  custom.ScaleAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isFavorite
                            ? MyThemes.primaryGradient
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade300,
                                ],
                              ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isFavorite
                                ? MyThemes.primaryColor.withOpacity(0.4)
                                : Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () async {
                          await _resepRepo.toggleFavorite(resepId, !isFavorite);
                          setState(() {});

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    isFavorite
                                        ? Icons.heart_broken
                                        : Icons.favorite,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isFavorite
                                        ? "Dihapus dari favorit"
                                        : "Ditambah ke favorit",
                                  ),
                                ],
                              ),
                              backgroundColor: MyThemes.primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: const custom.ShimmerLoading(height: 280, borderRadius: 25),
        );
      },
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
                gradient: MyThemes.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MyThemes.primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Belum Ada Resep Favorit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tambahkan resep favorit kamu\ndi sini! 🍳',
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
