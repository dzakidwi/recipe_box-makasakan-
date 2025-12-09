class KategoriResep {
  final int? id;
  final String namaKategori;
  final String? fotoPath;

  KategoriResep({
    this.id,
    required this.namaKategori,
    this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
      'foto_path': fotoPath,
    };
  }

  factory KategoriResep.fromMap(Map<String, dynamic> map) {
    return KategoriResep(
      id: map['id'],
      namaKategori: map['nama_kategori'],
      fotoPath: map['foto_path'],
    );
  }
}
