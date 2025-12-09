import 'package:recipe_box/db/db_helper.dart';
import 'package:recipe_box/models/kategori_model.dart';

class KategoriRepository {
  final db = DBHelper.instance;

  // CREATE
  Future<int> insertKategori(KategoriResep kategori) async {
    return await db.insert('kategori', kategori.toMap());
  }

  // READ
  Future<List<KategoriResep>> getAllKategori() async {
    final data = await db.getAll('kategori');
    return data.map((map) => KategoriResep.fromMap(map)).toList();
  }

  // UPDATE
  Future<int> updateKategori(KategoriResep kategori) async {
    return await db.updateById('kategori', kategori.id!, kategori.toMap());
  }

  // DELETE
  Future<int> deleteKategori(int id) async {
    return await db.deleteById('kategori', id);
  }

  // GET BY NAMA
  Future<KategoriResep?> getKategoriByNama(String nama) async {
    final result = await db.query(
      'kategori',
      where: 'nama_kategori = ?',
      whereArgs: [nama],
    );

    if (result.isNotEmpty) {
      return KategoriResep.fromMap(result.first);
    }
    return null;
  }

  // GET NAMA BY ID
  Future<String> getNamaById(int id) async {
    final result = await db.query(
      'kategori',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return KategoriResep.fromMap(result.first).namaKategori;
    }
    return '';
  }

}
