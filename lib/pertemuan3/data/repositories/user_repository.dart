// ============================================================================
// PERTEMUAN 3: REPOSITORY - ABSTRAKSI AKSES DATA
// ============================================================================
//
// REPOSITORY PATTERN memisahkan:
// - Domain/Business Logic dari implementasi data access
//
// KENAPA PAKAI ABSTRACT CLASS + IMPLEMENTATION?
// -------------------------------------------------------------------------
// 1. Cubit hanya tahu abstract class (interface)
// 2. Cubit tidak peduli datanya dari mana (API, local DB, cache)
// 3. Mudah mock untuk testing
// 4. Mudah ganti implementasi
//
// ALUR DATA:
// -------------------------------------------------------------------------
// Cubit -> Repository -> DataSource -> API
//              |
//              └─> (bisa juga) LocalDataSource -> SQLite
//
// ============================================================================

import '../models/user_model.dart';
import '../models/city_model.dart';
import '../datasources/user_remote_data_source.dart';

// =============================================================================
// ABSTRACT CLASS (INTERFACE)
// =============================================================================

/// Interface Repository untuk User
///
/// Mendefinisikan kontrak tanpa implementasi.
/// Cubit bergantung pada interface ini, bukan implementasi konkrit.
abstract class UserRepository {
  /// Get semua user
  Future<List<UserModel>> getUsers();

  /// Tambah user baru
  Future<UserModel> addUser(UserModel user);

  /// Get semua kota
  Future<List<CityModel>> getCities();
}

// =============================================================================
// IMPLEMENTATION CLASS
// =============================================================================

/// Implementasi konkrit dari UserRepository
///
/// Class ini menghubungkan domain dengan data source.
class UserRepositoryImpl implements UserRepository {
  /// Data source untuk akses API
  final UserRemoteDataSource dataSource;

  /// Constructor dengan dependency injection
  UserRepositoryImpl({required this.dataSource});

  // -------------------------------------------------------------------------
  // GET USERS
  // -------------------------------------------------------------------------
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      // Panggil data source
      return await dataSource.getUsers();
    } catch (e) {
      // Wrap error dengan pesan lebih informatif
      throw Exception('Repository error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // ADD USER
  // -------------------------------------------------------------------------
  @override
  Future<UserModel> addUser(UserModel user) async {
    try {
      return await dataSource.addUser(user);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // GET CITIES
  // -------------------------------------------------------------------------
  @override
  Future<List<CityModel>> getCities() async {
    try {
      return await dataSource.getCities();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
