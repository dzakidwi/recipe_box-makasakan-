import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipe_box.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_kategori TEXT NOT NULL,
        foto_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE resep (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        kategori_id INTEGER NOT NULL,
        porsi INTEGER NOT NULL,
        waktu_masak TEXT NOT NULL,
        image_path TEXT,
        is_favorite INTEGER NOT NULL,
        FOREIGN KEY(kategori_id) REFERENCES kategori(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE resep_bahan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        resep_id INTEGER,
        bahan TEXT,
        FOREIGN KEY(resep_id) REFERENCES resep(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE resep_langkah (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        resep_id INTEGER,
        langkah TEXT,
        FOREIGN KEY(resep_id) REFERENCES resep(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteById(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteWhere(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> updateById(String table, int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(table, data, where: "id = ?", whereArgs: [id]);
  }

  // UPDATE
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await instance.database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  // UPDATE WHERE
  Future<int> updateWhere(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, {}, where: where, whereArgs: whereArgs);
  }

  // QUERY
  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }
}
