// ============================================================================
// FILE: add_user_usecase.dart
// DESKRIPSI: Use Case untuk menambahkan user baru
// LOKASI: lib/features/user/domain/usecases/
// ============================================================================
//
// Use case ini mendemonstrasikan BUSINESS LOGIC dalam use case.
// Berbeda dengan GetUsersUseCase yang simple, use case ini memiliki
// VALIDASI sebelum menyimpan data.
//
// MENGAPA VALIDASI DI USE CASE?
// -------------------------------------------------------------------------
// 1. Validasi adalah bagian dari business logic
// 2. Memastikan data yang masuk ke repository sudah valid
// 3. Bisa digunakan dari berbagai UI (web, mobile) dengan validasi yang sama
// 4. UI validation bisa berbeda-beda, tapi business validation tetap sama
//
// ============================================================================

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk menambahkan user baru
///
/// Use case ini berisi:
/// - Validasi data user sebelum disimpan
/// - Pemanggilan repository untuk menyimpan data
class AddUserUseCase {
  // -------------------------------------------------------------------------
  // DEPENDENCY
  // -------------------------------------------------------------------------

  /// Repository untuk akses data user
  final UserRepository repository;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor dengan dependency injection
  AddUserUseCase({required this.repository});

  // -------------------------------------------------------------------------
  // EXECUTE METHOD
  // -------------------------------------------------------------------------

  /// Menjalankan use case untuk menambahkan user baru
  ///
  /// Parameter:
  /// - [user]: UserEntity yang akan ditambahkan
  ///
  /// Returns: UserEntity yang berhasil ditambahkan (dengan ID dari server)
  ///
  /// Throws:
  /// - Exception jika nama kosong
  /// - Exception jika email kosong
  /// - Exception jika terjadi error di repository
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// try {
  ///   final newUser = UserEntity(
  ///     id: '',
  ///     name: 'John Doe',
  ///     email: 'john@email.com',
  ///     // ... field lainnya
  ///   );
  ///   final result = await addUserUseCase.execute(newUser);
  ///   print('User berhasil ditambahkan dengan ID: ${result.id}');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  Future<UserEntity> execute(UserEntity user) async {
    // -----------------------------------------------------------------------
    // BUSINESS VALIDATION
    // -----------------------------------------------------------------------
    // Validasi ini adalah BUSINESS RULE yang harus dipenuhi
    // Berbeda dengan UI validation yang bisa di-bypass
    // -----------------------------------------------------------------------

    // Validasi: Nama tidak boleh kosong
    if (user.name.isEmpty) {
      throw Exception('Nama tidak boleh kosong');
    }

    // Validasi: Email tidak boleh kosong
    if (user.email.isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    // -----------------------------------------------------------------------
    // REPOSITORY CALL
    // -----------------------------------------------------------------------
    // Setelah validasi berhasil, panggil repository untuk menyimpan
    // -----------------------------------------------------------------------
    return await repository.addUser(user);
  }
}
