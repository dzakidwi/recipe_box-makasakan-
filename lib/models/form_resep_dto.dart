class FormResepDTO {
  int? id; // OPTIONAL, UNTUK EDIT RESEP
  String judul;
  int kategoriId; 
  String kategoriNama; 
  int porsi;
  String waktuMasak;
  List<String> bahan;
  List<String> langkah;
  String? imagePath;
  bool isFavorite;

  FormResepDTO({
    this.id,
    required this.judul,
    required this.kategoriId,
    required this.kategoriNama, 
    required this.porsi,
    required this.waktuMasak,
    required this.bahan,
    required this.langkah,
    this.imagePath,
    this.isFavorite = false,
  });
}
