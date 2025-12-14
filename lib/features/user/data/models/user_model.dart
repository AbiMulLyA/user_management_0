// ============================================================================
// FILE: user_model.dart
// DESKRIPSI: Model User - representasi data user dari API
// LOKASI: lib/features/user/data/models/
// ============================================================================
//
// MODEL adalah class di Data Layer yang bertugas:
// 1. Menerima data dari sumber eksternal (API, Database)
// 2. Mengkonversi data ke format yang bisa digunakan aplikasi (Entity)
// 3. Mengkonversi Entity ke format untuk dikirim ke API (JSON)
//
// PERBEDAAN MODEL vs ENTITY:
// -------------------------------------------------------------------------
// | Aspek          | Entity              | Model                          |
// |----------------|---------------------|--------------------------------|
// | Layer          | Domain              | Data                           |
// | Tanggung Jawab | Data murni          | Parsing & Serialization        |
// | Dependencies   | Tidak ada           | Bergantung pada Entity         |
// | Method         | Tidak ada           | fromJson(), toJson()           |
// -------------------------------------------------------------------------
//
// EXTENDS vs IMPLEMENTS:
// - Model EXTENDS Entity (inheritance)
// - Artinya Model adalah "spesialisasi" dari Entity
// - Model memiliki semua properties Entity + tambahan method parsing
//
// ============================================================================

import '../../domain/entities/user_entity.dart';

/// Model User - representasi data user dari API
///
/// Model ini berisi logic untuk:
/// - Parsing JSON dari API menjadi object Dart (fromJson)
/// - Mengkonversi object Dart menjadi JSON untuk API (toJson)
///
/// INHERITANCE:
/// UserModel extends UserEntity, artinya:
/// - UserModel memiliki semua properties UserEntity
/// - UserModel bisa digunakan di mana saja UserEntity bisa digunakan
/// - Ini contoh Liskov Substitution Principle (SOLID)
class UserModel extends UserEntity {
  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------
  // Constructor memanggil super() untuk menginisialisasi parent class (UserEntity)
  // 'super.id' adalah shorthand untuk mengirim parameter ke parent constructor
  // -------------------------------------------------------------------------

  /// Constructor untuk membuat UserModel
  const UserModel({
    required super.id, // Dikirim ke UserEntity.id
    required super.name, // Dikirim ke UserEntity.name
    required super.address, // Dikirim ke UserEntity.address
    required super.email, // Dikirim ke UserEntity.email
    required super.phoneNumber, // Dikirim ke UserEntity.phoneNumber
    required super.city, // Dikirim ke UserEntity.city
  });

  // -------------------------------------------------------------------------
  // FACTORY CONSTRUCTOR: fromJson
  // -------------------------------------------------------------------------
  // Factory constructor adalah constructor yang tidak selalu membuat instance baru
  // Digunakan untuk membuat object dari source lain (seperti JSON)
  //
  // JSON dari API biasanya berbentuk Map<String, dynamic>
  // Contoh:
  // {
  //   "id": "1",
  //   "name": "John Doe",
  //   "email": "john@email.com",
  //   ...
  // }
  // -------------------------------------------------------------------------

  /// Factory method untuk membuat UserModel dari JSON
  ///
  /// Parameter:
  /// - [json]: Map yang berisi data user dari API
  ///
  /// Returns: UserModel dengan data dari JSON
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// final json = {"id": "1", "name": "John", ...};
  /// final user = UserModel.fromJson(json);
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Menggunakan ?? '' untuk memberikan default value jika null
      // Ini mencegah error jika API mengembalikan null
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
    );
  }

  // -------------------------------------------------------------------------
  // METHOD: toJson
  // -------------------------------------------------------------------------
  // Mengkonversi object UserModel menjadi Map untuk dikirim ke API
  // Digunakan saat POST/PUT request
  //
  // CATATAN: 'id' tidak diinclude karena biasanya dibuat oleh server
  // -------------------------------------------------------------------------

  /// Method untuk convert UserModel ke JSON
  ///
  /// Returns: Map<String, dynamic> untuk dikirim ke API
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// final user = UserModel(name: "John", ...);
  /// final json = user.toJson();
  /// // json = {"name": "John", "address": "...", ...}
  /// ```
  Map<String, dynamic> toJson() {
    return {
      // ID tidak diinclude karena akan di-generate oleh API/server
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
    };
  }
}
