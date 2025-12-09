class ResepLangkah {
  final int? id;
  final int resepId;
  final String langkah;

  ResepLangkah({
    this.id,
    required this.resepId,
    required this.langkah,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resep_id': resepId,
      'langkah': langkah,
    };
  }

  factory ResepLangkah.fromMap(Map<String, dynamic> map) {
    return ResepLangkah(
      id: map['id'],
      resepId: map['resep_id'],
      langkah: map['langkah'],
    );
  }
}
