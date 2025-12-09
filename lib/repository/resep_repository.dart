import 'package:recipe_box/db/db_helper.dart';
import 'package:recipe_box/models/resep_model.dart';

class ResepRepository {
  final db = DBHelper.instance;

  // CREATE
  Future<int> insertResep(Resep resep) async {
    return await db.insert('resep', resep.toMap());
  }

  // READ ALL
  Future<List<Resep>> getAllResep() async {
    final data = await db.getAll('resep');
    return data.map((map) => Resep.fromMap(map)).toList();
  }

  // READ BY ID
  Future<Resep?> getResepById(int id) async {
    final data =
        await db.query('resep', where: "id = ?", whereArgs: [id]);

    if (data.isEmpty) return null;
    return Resep.fromMap(data.first);
  }

  // UPDATE
  Future<int> updateResep(Resep resep) async {
    return await db.updateById('resep', resep.id!, resep.toMap());
  }

  // DELETE
  Future<int> deleteResep(int id) async {
    return await db.deleteById('resep', id);
  }

  // TOGGLE FAVORITE
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await db.update(
      'resep',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
}

}
