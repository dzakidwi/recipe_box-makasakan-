// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/models/resep_model.dart';
import 'package:recipe_box/models/resep_bahan_model.dart';
import 'package:recipe_box/models/resep_langkah_model.dart';

import 'package:recipe_box/repository/resep_bahan_repository.dart';
import 'package:recipe_box/repository/resep_langkah_repository.dart';
import 'package:recipe_box/repository/resep_repository.dart';
import 'package:recipe_box/routing/routing.dart';

import 'package:recipe_box/themes/my_themes.dart';
import 'package:recipe_box/widgets/my_app_bar.dart';

class ScreenReviewResep extends StatefulWidget {
  final FormResepDTO resep;
  final bool isEdit;
  final int? resepId;

  const ScreenReviewResep({
    super.key,
    required this.resep,
    this.isEdit = false,
    this.resepId,
  });

  @override
  State<ScreenReviewResep> createState() => _ScreenReviewResepState();
}

class _ScreenReviewResepState extends State<ScreenReviewResep> {
  File? _selectedImage;
  bool _isFavorite = false;

  final _resepRepo = ResepRepository();
  final _bahanRepo = ResepBahanRepository();
  final _langkahRepo = ResepLangkahRepository();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.resep.isFavorite;
    if (widget.resep.imagePath != null) {
      _selectedImage = File(widget.resep.imagePath!);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        widget.resep.imagePath = picked.path;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      widget.resep.imagePath = null;
    });
  }

  Future<void> _saveResep() async {
    try {
      final resep = Resep(
        id: widget.isEdit ? widget.resepId : null,
        judul: widget.resep.judul,
        kategoriId: widget.resep.kategoriId,
        porsi: widget.resep.porsi,
        waktuMasak: widget.resep.waktuMasak,
        imagePath: widget.resep.imagePath,
        isFavorite: widget.resep.isFavorite,
      );

      int resepId;

      if (widget.isEdit && widget.resepId != null) {
        // UPDATE RESEP
        resepId = widget.resepId!;
        await _resepRepo.updateResep(resep);

        // HAPUS BAHAN & LANGKAH LAMA
        await _bahanRepo.deleteBahanByResep(resepId);
        await _langkahRepo.deleteLangkahByResep(resepId);
      } else {
        // INSERT RESEP BARU
        resepId = await _resepRepo.insertResep(resep);
      }

      // SIMPAN BAHAN BARU
      for (String b in widget.resep.bahan) {
        await _bahanRepo.insertBahan(ResepBahan(resepId: resepId, bahan: b));
      }

      // SIMPAN LANGKAH BARU
      for (String l in widget.resep.langkah) {
        await _langkahRepo.insertLangkah(
          ResepLangkah(resepId: resepId, langkah: l),
        );
      }

      // NOTIFIKASI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEdit
                  ? "Resep berhasil diedit!"
                  : "Resep berhasil disimpan!",
            ),
          ),
        );
        // ARAHKAN KE SCREEN TAMBAH RESEP

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Routing(selectedIndex: 2)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan resep: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.greyColor,
      appBar: MyAppBar(
        title: 'Resep Makananmu',
        backgroundColor: MyThemes.primaryColor,
        height: 100,
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        titleStyle: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: MyThemes.textColor,
        ),
        actionWidget: IconButton(
          icon: Icon(Icons.arrow_back, color: MyThemes.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GAMBAR / UPLOAD
              GestureDetector(
                onTap: _selectedImage == null ? _pickImage : _removeImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyThemes.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          ),
                        )
                      : const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // JUDUL + FAVORITE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.resep.judul,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                        widget.resep.isFavorite = _isFavorite;
                      });
                    },
                  ),
                ],
              ),

              Text(
                widget.resep.kategoriNama,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 16),

              // BAHAN
              const Text(
                "Bahan-bahan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.resep.bahan.map(
                (bahan) => Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bahan,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // LANGKAH
              const Text(
                "Langkah-langkah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.resep.langkah.map(
                (langkah) => Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        langkah,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyThemes.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveResep,
                  child: Text(
                    widget.isEdit ? "Update Resep" : "Simpan Resep",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
