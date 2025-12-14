// ============================================================================
// FILE: get_users_usecase.dart
// DESKRIPSI: Use Case untuk mendapatkan daftar user
// LOKASI: lib/features/user/domain/usecases/
// ============================================================================
//
// USE CASE adalah class yang berisi business logic untuk SATU aksi spesifik.
//
// PRINSIP USE CASE:
// -------------------------------------------------------------------------
// 1. SINGLE RESPONSIBILITY:
//    - Setiap use case hanya melakukan SATU hal
//    - GetUsersUseCase hanya untuk GET users, tidak untuk add/delete
//
// 2. BUSINESS LOGIC:
//    - Use case berisi validasi dan aturan bisnis
//    - Contoh: sorting, filtering, validasi data
//
// 3. ORCHESTRATION:
//    - Use case mengkoordinasi satu atau lebih repository
//    - Bisa memanggil multiple repositories jika diperlukan
//
// ALUR DATA:
// -------------------------------------------------------------------------
// UI (Page) -> Cubit -> UseCase -> Repository -> DataSource -> API
//                 |                                              |
//                 <--------- Response (UserEntity) <-------------
//
// ============================================================================

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list user
///
/// Use case ini bertugas untuk:
/// - Memanggil repository untuk mendapatkan data user
/// - (Opsional) Menambahkan business logic seperti sorting/filtering
///
/// PENGGUNAAN:
/// ```dart
/// final users = await getUsersUseCase.execute();
/// ```
class GetUsersUseCase {
  // -------------------------------------------------------------------------
  // DEPENDENCY
  // -------------------------------------------------------------------------
  // Use case bergantung pada Repository INTERFACE (abstract class)
  // Bukan pada implementasi konkrit (UserRepositoryImpl)
  // Ini adalah contoh Dependency Inversion Principle
  // -------------------------------------------------------------------------

  /// Repository untuk akses data user
  final UserRepository repository;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------
  // Repository di-inject melalui constructor (Dependency Injection)
  // Use case tidak membuat repository sendiri, tapi menerima dari luar
  // -------------------------------------------------------------------------

  /// Constructor dengan dependency injection
  GetUsersUseCase({required this.repository});

  // -------------------------------------------------------------------------
  // EXECUTE METHOD
  // -------------------------------------------------------------------------
  // Method utama yang dipanggil oleh Cubit/Presenter
  // Nama 'execute' adalah konvensi umum untuk use case
  // -------------------------------------------------------------------------

  /// Menjalankan use case untuk mendapatkan semua user
  ///
  /// Returns: List<UserEntity> berisi semua user
  /// Throws: Exception jika terjadi error di repository
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// try {
  ///   final users = await getUsersUseCase.execute();
  ///   print('Jumlah user: ${users.length}');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  Future<List<UserEntity>> execute() async {
    // Memanggil repository untuk mendapatkan data
    // Repository akan menentukan bagaimana data didapatkan (API, cache, dll)
    return await repository.getUsers();
  }
}
