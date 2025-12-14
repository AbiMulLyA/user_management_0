// ============================================================================
// PERTEMUAN 1: MODEL USER SEDERHANA
// ============================================================================
//
// Model adalah class yang merepresentasikan struktur data.
// Di sini kita buat model sederhana untuk data user dari API.
//
// STRUKTUR JSON DARI API:
// {
//   "id": "1",
//   "name": "John Doe",
//   "email": "john@email.com",
//   "address": "Jl. Contoh No. 123",
//   "phoneNumber": "08123456789",
//   "city": "Jakarta"
// }
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
  // Factory constructor adalah constructor khusus yang:
  // - Tidak selalu membuat instance baru
  // - Bisa melakukan logic sebelum membuat object
  // - Sering digunakan untuk parsing data
  //
  // -------------------------------------------------------------------------

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
    return UserModel(
      // Menggunakan ?? '' untuk memberikan default value jika null
      // Ini mencegah error jika API mengembalikan null
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
