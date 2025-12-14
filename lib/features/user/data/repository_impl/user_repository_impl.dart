// ============================================================================
// FILE: user_repository_impl.dart
// DESKRIPSI: Implementasi Repository - penghubung Domain dan Data Layer
// LOKASI: lib/features/user/data/repository_impl/
// ============================================================================
//
// REPOSITORY IMPLEMENTATION adalah implementasi konkrit dari Repository interface.
//
// PERAN REPOSITORY:
// -------------------------------------------------------------------------
// 1. Mengimplementasikan kontrak dari Domain Layer
// 2. Menghubungkan Domain Layer dengan Data Source
// 3. Mengkonversi Model (data layer) ke Entity (domain layer)
// 4. Memutuskan sumber data mana yang digunakan (API, cache, local DB)
//
// ALUR DATA:
// -------------------------------------------------------------------------
//
//   DOMAIN LAYER          DATA LAYER
//   +-----------+        +-------------------+        +-------------+
//   |           |        |                   |        |             |
//   | Use Case  | -----> | RepositoryImpl    | -----> | DataSource  |
//   |           |        |                   |        |             |
//   +-----------+        +-------------------+        +-------------+
//        |                      |                           |
//        |                      |                           v
//        |                      |                     +----------+
//        |                      |                     |   API    |
//        |                      |                     +----------+
//        v                      v
//   UserEntity <----------- UserModel <------------- JSON Response
//
// ============================================================================

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../models/user_model.dart';

/// Implementasi konkrit dari UserRepository
///
/// Class ini mengimplementasikan semua method yang didefinisikan
/// di abstract class UserRepository.
///
/// IMPLEMENTS vs EXTENDS:
/// - implements: harus mengimplementasikan SEMUA method dari interface
/// - extends: mewarisi implementasi dari parent class
class UserRepositoryImpl implements UserRepository {
  // -------------------------------------------------------------------------
  // DEPENDENCY
  // -------------------------------------------------------------------------

  /// Remote Data Source untuk komunikasi dengan API
  /// Repository menggunakan DataSource, bukan langsung ke HTTP Client
  final UserRemoteDataSource remoteDataSource;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor dengan dependency injection
  UserRepositoryImpl({required this.remoteDataSource});

  // -------------------------------------------------------------------------
  // GET USERS
  // -------------------------------------------------------------------------

  /// Mendapatkan semua user
  ///
  /// Alur:
  /// 1. Panggil remoteDataSource.getUsers()
  /// 2. DataSource mengembalikan List<UserModel>
  /// 3. Return sebagai List<UserEntity> (karena UserModel extends UserEntity)
  ///
  /// CATATAN:
  /// Karena UserModel extends UserEntity, kita bisa langsung return
  /// List<UserModel> sebagai List<UserEntity> (Liskov Substitution Principle)
  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      // Mendapatkan data dari remote data source
      final userModels = await remoteDataSource.getUsers();

      // Return sebagai List<UserEntity>
      // UserModel bisa digunakan sebagai UserEntity karena inheritance
      return userModels;
    } catch (e) {
      // Wrap error dengan konteks dari repository
      throw Exception('Repository error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // ADD USER
  // -------------------------------------------------------------------------

  /// Menambahkan user baru
  ///
  /// Alur:
  /// 1. Terima UserEntity dari Use Case (domain layer)
  /// 2. Convert UserEntity ke UserModel (data layer)
  /// 3. Kirim UserModel ke DataSource
  /// 4. Return hasil sebagai UserEntity
  ///
  /// MENGAPA PERLU CONVERT?
  /// - Use Case bekerja dengan Entity (tidak tahu tentang JSON/API)
  /// - DataSource bekerja dengan Model (tahu cara convert ke JSON)
  /// - Repository menjadi "penerjemah" di antara keduanya
  @override
  Future<UserEntity> addUser(UserEntity user) async {
    try {
      // ---------------------------------------------------------------------
      // LANGKAH 1: Convert UserEntity ke UserModel
      // ---------------------------------------------------------------------
      // UserEntity tidak punya toJson(), jadi kita buat UserModel
      // dengan data yang sama untuk dikirim ke API
      // ---------------------------------------------------------------------
      final userModel = UserModel(
        id: '', // ID akan di-generate oleh API
        name: user.name,
        address: user.address,
        email: user.email,
        phoneNumber: user.phoneNumber,
        city: user.city,
      );

      // ---------------------------------------------------------------------
      // LANGKAH 2: Kirim ke DataSource
      // ---------------------------------------------------------------------
      // DataSource akan:
      // - Convert Model ke JSON
      // - Kirim ke API via HTTP POST
      // - Return Model dengan ID dari server
      // ---------------------------------------------------------------------
      final result = await remoteDataSource.addUser(userModel);

      // Return sebagai UserEntity
      return result;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  // -------------------------------------------------------------------------
  // GET CITIES
  // -------------------------------------------------------------------------

  /// Mendapatkan semua kota
  ///
  /// Sama seperti getUsers, tapi untuk data kota
  @override
  Future<List<CityEntity>> getCities() async {
    try {
      final cityModels = await remoteDataSource.getCities();
      return cityModels;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
