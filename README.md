# 🍳 Aplikasi Manajemen Resep Masakan

Aplikasi Flutter dengan database SQLite untuk menyimpan, menampilkan, dan mengelola resep masakan secara offline.

---

## 📱 Fitur Utama
- Tambah resep lengkap dengan bahan dan langkah.
- Edit dan hapus resep yang sudah tersimpan.
- Menampilkan daftar resep yang tersimpan secara lokal.
- Pencarian resep berdasarkan nama atau kategori.
- Dapat berjalan tanpa koneksi internet (offline mode).

---

## 🧭 Alur Penggunaan

1. **Home Screen**
   - Menampilkan semua resep dari database.
   - Tombol ➕ untuk menambah resep baru.

2. **Tambah Resep**
   - Isi judul, deskripsi, kategori, waktu masak, dan jumlah porsi.
   - Tambahkan bahan-bahan dan langkah-langkah langsung dari form.
   - Tekan **Review** untuk meninjau data.
   - Tekan **Simpan** untuk menyimpan ke database.

3. **Penyimpanan ke Database**
   - Aplikasi akan otomatis membuat 3 record terpisah:
     - `resep` (data utama)
     - `bahan` (terkait dengan id_resep)
     - `langkah` (terkait dengan id_resep)
   - Semua disimpan dalam satu transaksi SQLite.

4. **Detail Resep**
   - Menampilkan seluruh informasi resep lengkap.
   - Mengambil data bahan & langkah dari tabel masing-masing.

5. **Edit & Hapus Resep**
   - Edit memungkinkan perubahan data langsung di form.
   - Hapus akan menghapus data dari semua tabel terkait (`resep`, `bahan`, `langkah`).

---

## 🧱 Struktur Database

### Tabel `resep`
| Kolom | Tipe | Deskripsi |
|-------|------|------------|
| id_resep | INTEGER (PK) | ID unik resep |
| judul | TEXT | Nama resep |
| deskripsi | TEXT | Penjelasan singkat |
| kategori | TEXT | Jenis resep |
| waktu | TEXT | Estimasi waktu masak |
| porsi | INTEGER | Jumlah porsi |
| gambar | TEXT | (opsional) path gambar lokal |

### Tabel `bahan`
| Kolom | Tipe | Deskripsi |
|-------|------|------------|
| id_bahan | INTEGER (PK) | ID bahan |
| id_resep | INTEGER (FK) | Foreign key ke resep |
| nama | TEXT | Nama bahan |
| jumlah | TEXT | Banyaknya bahan |
| satuan | TEXT | Satuan bahan |
| urutan | INTEGER | Posisi bahan |

### Tabel `langkah`
| Kolom | Tipe | Deskripsi |
|-------|------|------------|
| id_langkah | INTEGER (PK) | ID langkah |
| id_resep | INTEGER (FK) | Foreign key ke resep |
| deskripsi | TEXT | Uraian langkah |
| nomor_langkah | INTEGER | Urutan langkah |

---

## 🔗 Relasi Antar Tabel
"# recipe_box-makasakan-" 
