// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_box/models/form_resep_dto.dart';
import 'package:recipe_box/models/kategori_model.dart';
import 'package:recipe_box/repository/kategori_repository.dart';
import 'package:recipe_box/screens/screen_review_resep.dart';
import 'package:recipe_box/themes/my_themes.dart';

class ScreenEditResep extends StatefulWidget {
  final FormResepDTO resep;
  const ScreenEditResep({super.key, required this.resep});

  @override
  State<ScreenEditResep> createState() => _ScreenEditResepState();
}

class _ScreenEditResepState extends State<ScreenEditResep>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _kategoriRepo = KategoriRepository();
  late AnimationController _animationController;

  // CONTROLLERS
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  // DATA
  List<KategoriResep> _kategoriList = [];
  KategoriResep? _kategoriDipilih;
  File? _selectedImage;
  String? _imagePath;

  List<String> _bahanList = [];
  List<String> _langkahList = [];

  @override
  void initState() {
    super.initState();
    _loadKategori();
    _initializeData();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  void _initializeData() {
    // SET DATA KE CONTROLLER
    _judulController.text = widget.resep.judul;
    _porsiController.text = widget.resep.porsi.toString();
    _waktuController.text = widget.resep.waktuMasak;

    // SET IMAGE
    _imagePath = widget.resep.imagePath;
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      _selectedImage = File(_imagePath!);
    }

    // SET BAHAN & LANGKAH
    _bahanList = List.from(widget.resep.bahan);
    _langkahList = List.from(widget.resep.langkah);

    // Pastikan minimal ada 1 item
    if (_bahanList.isEmpty) _bahanList.add('');
    if (_langkahList.isEmpty) _langkahList.add('');
  }

  @override
  void dispose() {
    _animationController.dispose();
    _judulController.dispose();
    _porsiController.dispose();
    _waktuController.dispose();
    super.dispose();
  }

  Future<void> _loadKategori() async {
    final data = await _kategoriRepo.getAllKategori();
    setState(() {
      _kategoriList = data;
      // SET KATEGORI YANG SUDAH DIPILIH
      _kategoriDipilih = _kategoriList.firstWhere(
        (k) => k.id == widget.resep.kategoriId,
        orElse: () => KategoriResep(
          id: widget.resep.kategoriId,
          namaKategori: widget.resep.kategoriNama,
        ),
      );
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _imagePath = picked.path;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // MODERN APP BAR
          _buildModernAppBar(),

          // FORM CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE PICKER CARD
                    _buildImagePickerCard(),
                    const SizedBox(height: 20),

                    // INFO DASAR CARD
                    _buildInfoDasarCard(),
                    const SizedBox(height: 20),

                    // DETAIL CARD
                    _buildDetailCard(),
                    const SizedBox(height: 20),

                    // BAHAN CARD
                    _buildBahanCard(),
                    const SizedBox(height: 20),

                    // LANGKAH CARD
                    _buildLangkahCard(),
                    const SizedBox(height: 30),

                    // SUBMIT BUTTON
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== APP BAR ====================
  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: MyThemes.softShadow,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: MyThemes.textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: MyThemes.accentGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_note,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Edit Resep',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.resep.judul,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }

  // ==================== IMAGE PICKER ====================
  Widget _buildImagePickerCard() {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: MyThemes.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MyThemes.accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Foto Resep',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
                    ),
                  ),
                ],
              ),
            ),

            if (_selectedImage == null)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyThemes.greyColor,
                        MyThemes.greyColor.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: MyThemes.greyText.withOpacity(0.3),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: MyThemes.accentColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tap untuk ubah foto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MyThemes.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Foto lama akan diganti',
                        style: TextStyle(
                          fontSize: 14,
                          color: MyThemes.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 28,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: MyThemes.softShadow,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: MyThemes.accentColor,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: MyThemes.softShadow,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: MyThemes.primaryColor,
                            ),
                            onPressed: _removeImage,
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
    );
  }

  // ==================== INFO DASAR ====================
  Widget _buildInfoDasarCard() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: MyThemes.cardShadow,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MyThemes.accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Info Dasar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // JUDUL RESEP
              const Text(
                'Judul Resep',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MyThemes.textColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Nasi Goreng Spesial',
                  hintStyle: TextStyle(
                    color: MyThemes.greyText.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: MyThemes.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.title,
                    color: MyThemes.accentColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // KATEGORI
              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MyThemes.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: MyThemes.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: _kategoriDipilih?.namaKategori,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.category,
                      color: MyThemes.accentColor,
                    ),
                  ),
                  hint: const Text('Pilih kategori'),
                  items: _kategoriList.map((kategori) {
                    return DropdownMenuItem(
                      value: kategori.namaKategori,
                      child: Text(kategori.namaKategori),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _kategoriDipilih = _kategoriList.firstWhere(
                        (k) => k.namaKategori == value,
                      );
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih kategori';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== DETAIL ====================
  Widget _buildDetailCard() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: MyThemes.cardShadow,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MyThemes.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Detail Resep',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Waktu Masak',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MyThemes.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _waktuController,
                          decoration: InputDecoration(
                            hintText: '30 Menit',
                            hintStyle: TextStyle(
                              color: MyThemes.greyText.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: MyThemes.backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.schedule,
                              color: MyThemes.primaryColor,
                              size: 20,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Porsi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MyThemes.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _porsiController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '2 Porsi',
                            hintStyle: TextStyle(
                              color: MyThemes.greyText.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: MyThemes.backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.restaurant,
                              color: MyThemes.primaryColor,
                              size: 20,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
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
    );
  }

  // ==================== BAHAN ====================
  Widget _buildBahanCard() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: MyThemes.cardShadow,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MyThemes.accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_basket,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Bahan-bahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: MyThemes.accentGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_bahanList.length} item',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ..._bahanList.asMap().entries.map((entry) {
                int index = entry.key;
                String bahan = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: MyThemes.accentGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: bahan,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Ayam 500gr',
                            hintStyle: TextStyle(
                              color: MyThemes.greyText.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: MyThemes.backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            _bahanList[index] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bahan tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_bahanList.length > 1)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: MyThemes.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _bahanList.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _bahanList.add('');
                    });
                  },
                  icon: const Icon(Icons.add, color: MyThemes.accentColor),
                  label: const Text(
                    'Tambah Bahan',
                    style: TextStyle(
                      color: MyThemes.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: MyThemes.accentColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== LANGKAH ====================
  Widget _buildLangkahCard() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: MyThemes.cardShadow,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MyThemes.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.format_list_numbered,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Langkah-langkah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyThemes.textColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: MyThemes.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_langkahList.length} step',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ..._langkahList.asMap().entries.map((entry) {
                int index = entry.key;
                String langkah = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: MyThemes.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: langkah,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Panaskan minyak di wajan...',
                            hintStyle: TextStyle(
                              color: MyThemes.greyText.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: MyThemes.backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            _langkahList[index] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Langkah tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_langkahList.length > 1)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: MyThemes.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _langkahList.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _langkahList.add('');
                    });
                  },
                  icon: const Icon(Icons.add, color: MyThemes.primaryColor),
                  label: const Text(
                    'Tambah Langkah',
                    style: TextStyle(
                      color: MyThemes.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: MyThemes.primaryColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== SUBMIT BUTTON ====================
  Widget _buildSubmitButton() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: MyThemes.accentGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: MyThemes.accentColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onReviewPressed,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Review Perubahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== VALIDATION & SUBMIT ====================
  void _onReviewPressed() {
    if (_kategoriDipilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text('Pilih kategori terlebih dahulu'),
            ],
          ),
          backgroundColor: MyThemes.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Validasi bahan & langkah tidak kosong
    if (_bahanList.any((b) => b.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text('Semua bahan harus diisi'),
            ],
          ),
          backgroundColor: MyThemes.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_langkahList.any((l) => l.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Text('Semua langkah harus diisi'),
            ],
          ),
          backgroundColor: MyThemes.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final resepDTO = FormResepDTO(
        judul: _judulController.text,
        kategoriId: _kategoriDipilih!.id!,
        kategoriNama: _kategoriDipilih!.namaKategori,
        porsi:
            int.tryParse(
              _porsiController.text.replaceAll(RegExp(r'[^0-9]'), ''),
            ) ??
            1,
        waktuMasak: _waktuController.text,
        bahan: _bahanList.where((b) => b.trim().isNotEmpty).toList(),
        langkah: _langkahList.where((l) => l.trim().isNotEmpty).toList(),
        imagePath: _imagePath,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScreenReviewResep(
            resep: resepDTO,
            isEdit: true,
            resepId: widget.resep.id,
          ),
        ),
      );
    }
  }
}
