class ResepBahan {
  final int? id;
  final int resepId;
  final String bahan;

  ResepBahan({
    this.id,
    required this.resepId,
    required this.bahan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resep_id': resepId,
      'bahan': bahan,
    };
  }

  factory ResepBahan.fromMap(Map<String, dynamic> map) {
    return ResepBahan(
      id: map['id'],
      resepId: map['resep_id'],
      bahan: map['bahan'],
    );
  }
}
