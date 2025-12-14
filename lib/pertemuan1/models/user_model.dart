// ============================================================================
// PERTEMUAN 1: MODEL USER SEDERHANA
// ============================================================================
//
// Model adalah class yang merepresentasikan struktur data.
// Di sini kita buat model sederhana untuk data user dari API.
//
// ============================================================================
// APA ITU JSON?
// ============================================================================
// JSON (JavaScript Object Notation) adalah FORMAT TEKS untuk menyimpan dan
// mengirim data. JSON sangat populer untuk komunikasi antara aplikasi dan API.
//
// MENGAPA JSON PENTING?
// - Format standar yang digunakan hampir semua API modern
// - Mudah dibaca oleh manusia DAN komputer
// - Ringan (lightweight) dibanding XML
// - Bisa dipakai di semua bahasa pemrograman
//
// STRUKTUR JSON:
// - Object: menggunakan kurung kurawal { }
// - Array: menggunakan kurung siku [ ]
// - Key-Value: menggunakan titik dua :
// - String harus menggunakan tanda kutip ganda " "
//
// CONTOH JSON DARI API KITA:
// {
//   "id": "1",
//   "name": "John Doe",
//   "email": "john@email.com",
//   "address": "Jl. Contoh No. 123",
//   "phoneNumber": "08123456789",
//   "city": "Jakarta"
// }
//
// Di Dart, JSON di-represent sebagai Map<String, dynamic>:
// - String = key (nama field seperti "id", "name", dll)
// - dynamic = value (bisa String, int, bool, List, atau Map lagi)
//
// ============================================================================

/// Model User sederhana
///
/// Class ini bertugas:
/// 1. Menyimpan data user
/// 2. Mengkonversi JSON dari API menjadi object Dart
class UserModel {
  // -------------------------------------------------------------------------
  // PROPERTIES
  // -------------------------------------------------------------------------
  // Semua properties menggunakan 'final' karena nilainya tidak akan berubah
  // setelah object dibuat (immutable)
  // -------------------------------------------------------------------------

  /// ID unik user dari database
  final String id;

  /// Nama lengkap user
  final String name;

  /// Alamat email user
  final String email;

  /// Alamat rumah user
  final String address;

  /// Nomor telepon user
  final String phoneNumber;

  /// Kota tempat tinggal user
  final String city;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor untuk membuat UserModel
  ///
  /// 'required' artinya parameter WAJIB diisi
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.city,
  });

  // -------------------------------------------------------------------------
  // FACTORY CONSTRUCTOR: fromJson
  // -------------------------------------------------------------------------
  //
  // =====================================================================
  // APA ITU .fromJson DAN MENGAPA KITA BUTUH INI?
  // =====================================================================
  //
  // Ketika kita mendapat data dari API, data tersebut adalah STRING JSON.
  // Contoh: '{"id": "1", "name": "John"}'
  //
  // Masalahnya:
  // - Dart tidak mengerti struktur JSON secara langsung
  // - Kita perlu mengkonversi JSON menjadi Object Dart (UserModel)
  //
  // Solusi: Buat method .fromJson untuk "translate" JSON ke Object Dart
  //
  // ANALOGI:
  // JSON adalah "bahasa asing" dari API
  // .fromJson adalah "penerjemah" yang mengubahnya jadi bahasa Dart
  //
  // ALUR KONVERSI:
  // 1. API mengirim: '{"id": "1", "name": "John"}' (String JSON)
  // 2. json.decode() mengubah ke: {"id": "1", "name": "John"} (Map)
  // 3. .fromJson() mengubah ke: UserModel(id: "1", name: "John") (Object)
  //
  // Factory constructor adalah constructor khusus yang:
  // - Tidak selalu membuat instance baru
  // - Bisa melakukan logic sebelum membuat object
  // - Sering digunakan untuk parsing data
  //
  // =====================================================================

  /// Membuat UserModel dari JSON (Map)
  ///
  /// Parameter:
  /// - [json]: Data dalam bentuk Map<String, dynamic> dari API
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// final jsonData = {"id": "1", "name": "John", ...};
  /// final user = UserModel.fromJson(jsonData);
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // -----------------------------------------------------------------------
    // CARA MEMBACA KODE INI:
    // -----------------------------------------------------------------------
    // json['id'] artinya: ambil value dari key 'id' dalam Map json
    //
    // Contoh jika json = {"id": "1", "name": "John"}
    // - json['id'] hasilnya "1"
    // - json['name'] hasilnya "John"
    //
    // Operator ?? adalah "null-aware operator"
    // Artinya: jika nilai di sebelah kiri null, gunakan nilai di sebelah kanan
    // Contoh: json['id'] ?? '' artinya:
    //   - Jika json['id'] ada nilainya, gunakan nilai itu
    //   - Jika json['id'] null, gunakan '' (string kosong)
    // -----------------------------------------------------------------------
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
