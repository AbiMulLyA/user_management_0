// ============================================================================
// FILE: get_cities_usecase.dart
// DESKRIPSI: Use Case untuk mendapatkan daftar kota
// LOKASI: lib/features/user/domain/usecases/
// ============================================================================
//
// Use case sederhana untuk mendapatkan daftar kota.
// Digunakan untuk mengisi dropdown filter kota di UI.
//
// ============================================================================

import '../entities/city_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list kota
///
/// Use case ini digunakan untuk:
/// - Mengisi dropdown filter kota
/// - Mengisi pilihan kota di form tambah user
class GetCitiesUseCase {
  // -------------------------------------------------------------------------
  // DEPENDENCY
  // -------------------------------------------------------------------------

  /// Repository untuk akses data
  /// Menggunakan UserRepository karena city masih bagian dari user feature
  final UserRepository repository;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor dengan dependency injection
  GetCitiesUseCase({required this.repository});

  // -------------------------------------------------------------------------
  // EXECUTE METHOD
  // -------------------------------------------------------------------------

  /// Menjalankan use case untuk mendapatkan semua kota
  ///
  /// Returns: List<CityEntity> berisi semua kota
  /// Throws: Exception jika terjadi error di repository
  Future<List<CityEntity>> execute() async {
    return await repository.getCities();
  }
}
