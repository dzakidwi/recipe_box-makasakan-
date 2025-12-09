class Resep {
  final int? id;
  final String judul;
  final int kategoriId; // ganti dari String kategori
  final int porsi;
  final String waktuMasak;
  String? imagePath;
  bool isFavorite;

  Resep({
    this.id,
    required this.judul,
    required this.kategoriId,
    required this.porsi,
    required this.waktuMasak,
    this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'kategori_id': kategoriId,
      'porsi': porsi,
      'waktu_masak': waktuMasak,
      'image_path': imagePath,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Resep.fromMap(Map<String, dynamic> map) {
    return Resep(
      id: map['id'],
      judul: map['judul'],
      kategoriId: map['kategori_id'],
      porsi: map['porsi'],
      waktuMasak: map['waktu_masak'],
      imagePath: map['image_path'],
      isFavorite: map['is_favorite'] == 1,
    );
  }
}
