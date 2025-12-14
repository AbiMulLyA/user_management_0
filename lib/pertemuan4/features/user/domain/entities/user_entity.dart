// ============================================================================
// PERTEMUAN 4: USER ENTITY - DOMAIN LAYER
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 4!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 3.
//
// Di Pertemuan 3, kita langsung pakai Model:
//   class UserModel { ... }
//
// Di Pertemuan 4, kita memisahkan Entity dan Model:
//   Entity → Data murni di Domain Layer
//   Model  → Extends Entity + fromJson/toJson di Data Layer
//
// PERBEDAAN:
// | Aspek      | Model (P3)           | Entity (P4)       |
// |------------|----------------------|-------------------|
// | Layer      | Data                 | Domain            |
// | Tujuan     | Parsing JSON         | Data murni        |
// | fromJson   | Ada                  | Tidak ada         |
// | toJson     | Ada                  | Tidak ada         |
// | Dependencies | Tahu tentang API   | Tidak tahu API    |
//
// KENAPA DIPISAH?
// - Domain layer tidak boleh bergantung pada format data eksternal
// - Jika API berubah, hanya Model yang perlu diubah
// - Business logic bekerja dengan Entity, bukan format data
//
// ============================================================================

import 'package:equatable/equatable.dart';

/// Entity User - representasi data user di domain layer
///
/// 📌 JEJAK PERTEMUAN 3:
/// Ini adalah "pemisahan" dari UserModel di Pertemuan 3.
/// UserModel sekarang EXTENDS UserEntity ini.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String city;

  const UserEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  // ==========================================================================
  // 📌 PERHATIKAN: TIDAK ADA fromJson/toJson!
  // ==========================================================================
  // Di Pertemuan 3, UserModel punya fromJson/toJson.
  // Di Pertemuan 4:
  //   - Entity TIDAK punya (di sini)
  //   - Model punya (di data/models/user_model.dart)
  //
  // Entity fokus pada data murni, tidak tahu tentang JSON atau API.
  // ==========================================================================

  @override
  List<Object?> get props => [id, name, address, email, phoneNumber, city];
}
