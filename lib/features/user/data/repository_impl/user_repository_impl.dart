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
//
// ============================================================================

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../models/user_model.dart';

/// Implementasi konkrit dari UserRepository
class UserRepositoryImpl implements UserRepository {
  // =========================================================================
  // DEPENDENCY INJECTION - PENJELASAN LENGKAP
  // =========================================================================
  //
  // LIHAT PROPERTY INI:
  //   final UserRemoteDataSource remoteDataSource;
  //
  // Class ini BUTUH remoteDataSource untuk bekerja.
  // Tapi perhatikan: kita TIDAK membuat remoteDataSource di sini!
  //
  // ❌ CARA YANG SALAH (tanpa Dependency Injection):
  //    class UserRepositoryImpl {
  //      final remoteDataSource = UserRemoteDataSourceImpl(client: http.Client());
  //    }
  //
  //    Masalah:
  //    - UserRepositoryImpl terikat erat dengan UserRemoteDataSourceImpl
  //    - Susah untuk testing (tidak bisa pakai mock/fake DataSource)
  //    - Susah untuk ganti implementasi
  //
  // ✅ CARA YANG BENAR (dengan Dependency Injection):
  //    class UserRepositoryImpl {
  //      final UserRemoteDataSource remoteDataSource;  // Deklarasi saja
  //      UserRepositoryImpl({required this.remoteDataSource});  // Diberikan dari luar
  //    }
  //
  //    Keuntungan:
  //    - UserRepositoryImpl tidak peduli DataSource dari mana
  //    - Bisa diganti dengan mock DataSource saat testing
  //    - Lebih fleksibel
  //
  // DI MANA remoteDataSource DIBUAT DAN DIBERIKAN?
  // -------------------------------------------------------------------------
  // Di file injector.dart:
  //
  //    // Buat DataSource dulu
  //    userRemoteDataSource = UserRemoteDataSourceImpl(client: httpClient);
  //
  //    // Baru buat Repository, BERIKAN DataSource yang sudah dibuat
  //    userRepository = UserRepositoryImpl(
  //      remoteDataSource: userRemoteDataSource,  // <- Ini yang "diinject"
  //    );
  //
  // =========================================================================

  /// Remote Data Source untuk komunikasi dengan API
  /// TIDAK dibuat di sini, tapi DIBERIKAN melalui constructor
  final UserRemoteDataSource remoteDataSource;

  // =========================================================================
  // CONSTRUCTOR DENGAN DEPENDENCY INJECTION
  // =========================================================================
  //
  // ANATOMI CONSTRUCTOR INI:
  //
  //   UserRepositoryImpl({required this.remoteDataSource});
  //   │                  │        │    │
  //   │                  │        │    └── this.remoteDataSource = langsung assign
  //   │                  │        │        ke property remoteDataSource di atas
  //   │                  │        │
  //   │                  │        └── required = wajib diisi, tidak boleh kosong
  //   │                  │
  //   │                  └── {} = named parameter (parameter dengan nama)
  //   │                      Cara pakai: UserRepositoryImpl(remoteDataSource: xxx)
  //   │
  //   └── Nama constructor (sama dengan nama class)
  //
  // CONTOH PENGGUNAAN:
  //   final dataSource = UserRemoteDataSourceImpl(...);
  //   final repository = UserRepositoryImpl(remoteDataSource: dataSource);
  //
  // =========================================================================

  UserRepositoryImpl({required this.remoteDataSource});

  // =========================================================================
  // IMPLEMENTASI METHOD
  // =========================================================================

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      // Panggil DataSource untuk ambil data dari API
      final userModels = await remoteDataSource.getUsers();
      // Return sebagai List<UserEntity>
      return userModels;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<UserEntity> addUser(UserEntity user) async {
    try {
      // Convert UserEntity ke UserModel untuk dikirim ke API
      final userModel = UserModel(
        id: '',
        name: user.name,
        address: user.address,
        email: user.email,
        phoneNumber: user.phoneNumber,
        city: user.city,
      );

      // Kirim ke DataSource
      final result = await remoteDataSource.addUser(userModel);
      return result;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

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
