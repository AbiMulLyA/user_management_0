// ============================================================================
// PERTEMUAN 4: REPOSITORY INTERFACE - DOMAIN LAYER
// ============================================================================
//
// REPOSITORY INTERFACE (Abstract Class) mendefinisikan KONTRAK:
// - Method apa saja yang harus ada
// - Parameter dan return type
//
// DEPENDENCY INVERSION PRINCIPLE:
// - Domain layer mendefinisikan APA yang dibutuhkan (interface)
// - Data layer menyediakan BAGAIMANA caranya (implementation)
//
// KENAPA DI DOMAIN LAYER?
// - Agar Domain tidak bergantung pada Data layer
// - Domain hanya tahu "ada repository yang bisa getUsers()"
// - Tidak peduli apakah dari API, database, atau cache
//
// ============================================================================

import '../entities/user_entity.dart';
import '../entities/city_entity.dart';

/// Repository interface di domain layer
abstract class UserRepository {
  /// Mendapatkan semua user
  Future<List<UserEntity>> getUsers();

  /// Menambahkan user baru
  Future<UserEntity> addUser(UserEntity user);

  /// Mendapatkan semua kota
  Future<List<CityEntity>> getCities();
}
