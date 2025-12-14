// ============================================================================
// FILE: user_repository.dart
// DESKRIPSI: Repository Interface (Abstract Class) di Domain Layer
// LOKASI: lib/features/user/domain/repositories/
// ============================================================================
//
// REPOSITORY PATTERN adalah design pattern yang memisahkan logic akses data
// dari business logic.
//
// MENGAPA MENGGUNAKAN ABSTRACT CLASS (INTERFACE)?
// -------------------------------------------------------------------------
// 1. DEPENDENCY INVERSION PRINCIPLE:
//    - Domain layer mendefinisikan APA yang dibutuhkan (interface)
//    - Data layer menyediakan BAGAIMANA cara mendapatkannya (implementation)
//
// 2. LOOSE COUPLING:
//    - Use Case tidak perlu tahu cara data didapatkan
//    - Bisa dari API, Database lokal, atau mock data
//
// 3. TESTABILITY:
//    - Saat testing, bisa menggunakan mock repository
//    - Tidak perlu koneksi ke API asli
//
// ANALOGI:
// -------------------------------------------------------------------------
// Bayangkan Repository seperti "kontrak kerja":
// - Interface = Kontrak yang menjelaskan APA yang harus dilakukan
// - Implementation = Pekerja yang melakukan pekerjaan sesuai kontrak
// - Use Case = Manager yang hanya tahu kontrak, tidak perlu tahu siapa pekerjanya
//
// ============================================================================

import '../entities/user_entity.dart';
import '../entities/city_entity.dart';

/// Repository interface di domain layer
///
/// ABSTRACT CLASS artinya:
/// - Tidak bisa dibuat instance-nya langsung
/// - Harus ada class lain yang mengimplementasikan (extends/implements)
/// - Mendefinisikan "kontrak" method apa saja yang harus ada
///
/// Class yang mengimplementasikan: UserRepositoryImpl (di data layer)
abstract class UserRepository {
  // -------------------------------------------------------------------------
  // METHOD DEFINITIONS (KONTRAK)
  // -------------------------------------------------------------------------
  // Semua method adalah abstract (tanpa body/implementasi)
  // Implementasi konkrit ada di UserRepositoryImpl
  // -------------------------------------------------------------------------

  /// Mendapatkan semua user dari data source
  ///
  /// Returns: List berisi semua UserEntity
  /// Throws: Exception jika terjadi error
  Future<List<UserEntity>> getUsers();

  /// Menambahkan user baru ke data source
  ///
  /// Parameter:
  /// - [user]: UserEntity yang akan ditambahkan
  ///
  /// Returns: UserEntity yang berhasil ditambahkan (dengan ID dari server)
  /// Throws: Exception jika terjadi error
  Future<UserEntity> addUser(UserEntity user);

  /// Mendapatkan semua kota dari data source
  ///
  /// Returns: List berisi semua CityEntity
  /// Throws: Exception jika terjadi error
  Future<List<CityEntity>> getCities();
}
