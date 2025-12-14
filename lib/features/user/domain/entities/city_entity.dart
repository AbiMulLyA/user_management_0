// ============================================================================
// FILE: city_entity.dart
// DESKRIPSI: Entity City - representasi data kota di Domain Layer
// LOKASI: lib/features/user/domain/entities/
// ============================================================================
//
// Entity City adalah representasi sederhana dari data kota.
// Digunakan untuk dropdown filter berdasarkan kota.
//
// Sama seperti UserEntity, CityEntity juga:
// - Immutable (tidak bisa diubah setelah dibuat)
// - Menggunakan Equatable untuk perbandingan
// - Tidak bergantung pada format data eksternal
//
// ============================================================================

import 'package:equatable/equatable.dart';

/// Entity City - representasi data kota di domain layer
///
/// Entity ini digunakan untuk:
/// - Menampilkan daftar kota di dropdown filter
/// - Menyimpan data kota yang dipilih user
class CityEntity extends Equatable {
  // -------------------------------------------------------------------------
  // PROPERTIES
  // -------------------------------------------------------------------------

  /// ID unik kota (dari database/API)
  final String id;

  /// Nama kota (contoh: "Jakarta", "Bandung", "Surabaya")
  final String name;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor untuk membuat CityEntity
  const CityEntity({
    required this.id,
    required this.name,
  });

  // -------------------------------------------------------------------------
  // EQUATABLE PROPS
  // -------------------------------------------------------------------------

  /// List properties untuk perbandingan equality
  @override
  List<Object?> get props => [id, name];
}
