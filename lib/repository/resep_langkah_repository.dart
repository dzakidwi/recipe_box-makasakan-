import 'package:recipe_box/db/db_helper.dart';
import 'package:recipe_box/models/resep_langkah_model.dart';

class ResepLangkahRepository {
  final db = DBHelper.instance;

  // INSERT
  Future<int> insertLangkah(ResepLangkah langkah) async {
    return await db.insert('resep_langkah', langkah.toMap());
  }

  // AMBIL SEMUA DATA LANGKAH BERDASARKAN RESEP ID
  Future<List<ResepLangkah>> getLangkahByResep(int resepId) async {
    final data = await db.query(
      'resep_langkah',
      where: "resep_id = ?",
      whereArgs: [resepId],
    );

    return data.map((m) => ResepLangkah.fromMap(m)).toList();
  }

  // UPDATE LANGKAH BERDASARKAN RESEP ID DAN LANGKAH ID
  Future<int> updateLangkah(int resepId, int langkahId) async{
    return await db.updateWhere(
      'resep_langkah',
      where: "resep_id = ? AND id = ?",
      whereArgs: [resepId, langkahId],
    );
  }

  // DELETE SEMUA LANGKAH BERDASARKAN RESEP ID DAN LANGKAH ID
  Future<int> deleteLangkahByResep(int resepId) async {
    return await db.deleteWhere(
      'resep_langkah',
      where: "resep_id = ?",
      whereArgs: [resepId],
    );
  }
}
