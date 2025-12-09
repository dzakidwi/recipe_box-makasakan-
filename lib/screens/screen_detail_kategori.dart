import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_box/models/kategori_model.dart';
import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/repository/resep_repository.dart';
import 'package:recipe_box/screens/screen_detail_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';

class ScreenDetailKategori extends StatefulWidget {
  final KategoriResep kategori;

  const ScreenDetailKategori({super.key, required this.kategori});

  @override
  State<ScreenDetailKategori> createState() => _ScreenDetailKategoriState();
}

class _ScreenDetailKategoriState extends State<ScreenDetailKategori> {
  final ResepRepository _resepRepo = ResepRepository();

  List<FormResepDTO> resepList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResepByKategori();
  }

  Future<void> _loadResepByKategori() async {
    final semuaResep = await _resepRepo.getAllResep();

    setState(() {
      resepList = semuaResep
          .where((resep) => resep.kategoriId == widget.kategori.id)
          .map(
            (resep) => FormResepDTO(
              id: resep.id,
              judul: resep.judul,
              kategoriId: resep.kategoriId,
              kategoriNama: widget.kategori.namaKategori,
              porsi: resep.porsi,
              waktuMasak: resep.waktuMasak,
              bahan: [],
              langkah: [],
              imagePath: resep.imagePath,
              isFavorite: resep.isFavorite,
            ),
          )
          .toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kategori.namaKategori),
        backgroundColor: MyThemes.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 220,
            child:
                (widget.kategori.fotoPath != null &&
                    File(widget.kategori.fotoPath!).existsSync())
                ? Image.file(File(widget.kategori.fotoPath!), fit: BoxFit.cover)
                : Container(
                    decoration: BoxDecoration(gradient: MyThemes.coolGradient),
                    child: const Center(
                      child: Icon(
                        Icons.fastfood,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daftar Resep",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : resepList.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada resep di kategori ini",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: resepList.length,
                    itemBuilder: (context, index) {
                      final resep = resepList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(20),
                                ),
                                child: resep.imagePath != null
                                    ? Image.file(
                                        File(resep.imagePath!),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.image),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resep.judul,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${resep.waktuMasak} • ${resep.porsi} porsi",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
