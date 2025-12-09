import 'package:recipe_box/db/db_helper.dart';
import 'package:recipe_box/models/resep_bahan_model.dart';

class ResepBahanRepository {
  final db = DBHelper.instance;

  // INSERT
  Future<int> insertBahan(ResepBahan bahan) async {
    return await db.insert('resep_bahan', bahan.toMap());
  }

  // AMBIL SEMUA DATA BAHAN BERDASARKAN RESEP ID
  Future<List<ResepBahan>> getBahanByResep(int resepId) async {
    final data = await db.query(
      'resep_bahan',
      where: "resep_id = ?",
      whereArgs: [resepId],
    );

    return data.map((map) => ResepBahan.fromMap(map)).toList();
  }

  // DELETE SEMUA BAHAN BERDASARKAN RESEP ID
  Future<int> deleteBahanByResep(int resepId) async {
    return await db.deleteWhere(
      'resep_bahan',
      where: "resep_id = ?",
      whereArgs: [resepId],
    );
  }

  // UPDATE BAHAN BERDASARKAN RESEP ID DAN BAHAN ID
  Future<int> updateBahan(int resepId, int bahanId) async {
    return await db.updateWhere(
      'resep_bahan',
      where: "resep_id = ? AND id = ?",
      whereArgs: [resepId, bahanId],
    );
  }
}
