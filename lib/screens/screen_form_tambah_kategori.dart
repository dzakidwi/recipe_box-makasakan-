// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_box/models/kategori_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';

class ScreenFormTambahKategori extends StatefulWidget {
  const ScreenFormTambahKategori({super.key});

  @override
  State<ScreenFormTambahKategori> createState() => _ScreenFormTambahKategoriState();
}

class _ScreenFormTambahKategoriState extends State<ScreenFormTambahKategori> {
  final repo = KategoriRepository();
  final TextEditingController _kategoriController = TextEditingController();
  File? _fotoFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _ambilFoto() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _fotoFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TITLE
            Text(
              "Tambah Kategori",
              style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // UPLOAD FOTO
            GestureDetector(
              onTap: _ambilFoto,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _fotoFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("Tambah Foto Kategori",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _fotoFile!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // HAPUS FOTO
                          Positioned(
                            top: 8,
                            right: 8,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _fotoFile = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // TEXTFIELD
            TextField(
              controller: _kategoriController,
              decoration: InputDecoration(
                labelText: "Nama Kategori",
                hintText: "misalnya: Dessert, Minuman, Sarapan",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // BATAL
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),

                const SizedBox(width: 10),

                // SIMPAN
                ElevatedButton(
                  onPressed: () async {
                    if (_kategoriController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Nama kategori tidak boleh kosong")),
                      );
                      return;
                    }

                    await repo.insertKategori(
                      KategoriResep(
                        namaKategori: _kategoriController.text,
                        fotoPath: _fotoFile?.path,
                      ),
                    );

                    Navigator.pop(context);
                  },

                  child: const Text("Simpan"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
