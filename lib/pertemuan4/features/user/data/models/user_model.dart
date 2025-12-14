// ============================================================================
// PERTEMUAN 4: USER MODEL - DATA LAYER
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 3:
// ============================================================================
// Di Pertemuan 3, UserModel adalah class standalone dengan semua property.
// Di Pertemuan 4, UserModel EXTENDS UserEntity.
//
// KODE LAMA (Pertemuan 3):
// -----------------------------------------------------------------
// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   ...
//
//   factory UserModel.fromJson(Map<String, dynamic> json) { ... }
//   Map<String, dynamic> toJson() { ... }
// }
//
// SEKARANG (Pertemuan 4):
// UserModel extends UserEntity, hanya tambah fromJson/toJson
// ============================================================================

import '../../domain/entities/user_entity.dart';

/// Model User - dengan parsing JSON
///
/// 🔄 PERUBAHAN:
/// Pertemuan 3: class UserModel { properties... }
/// Pertemuan 4: class UserModel extends UserEntity { }
class UserModel extends UserEntity {
  // =========================================================================
  // 📌 PERHATIKAN: TIDAK ADA property declarations!
  // =========================================================================
  // Di Pertemuan 3, semua property dideklarasikan di sini.
  // Di Pertemuan 4, property sudah ada di UserEntity (parent class).
  // Kita hanya perlu call super constructor.
  // =========================================================================

  const UserModel({
    required super.id,
    required super.name,
    required super.address,
    required super.email,
    required super.phoneNumber,
    required super.city,
  });

  /// Factory method untuk parsing JSON dari API
  ///
  /// 📌 SAMA seperti Pertemuan 3, tapi sekarang return UserModel
  /// yang extends UserEntity
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
    );
  }

  /// Method untuk konversi ke JSON (untuk POST request)
  ///
  /// 📌 SAMA seperti Pertemuan 3
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
    };
  }
}
