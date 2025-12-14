// ============================================================================
// FILE: add_user_usecase.dart
// DESKRIPSI: Use Case untuk menambahkan user baru
// LOKASI: lib/features/user/domain/usecases/
// ============================================================================
//
// Use case ini bertugas untuk menambahkan user baru ke sistem.

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk menambahkan user baru
///
/// Use case ini menerima UserEntity dan menyimpannya melalui repository.
/// Validasi sudah ditangani di UI (form validation).
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
  /// Throws: Exception jika terjadi error di repository
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
    // Langsung panggil repository untuk menyimpan user
    // Validasi sudah dilakukan di UI layer
    return await repository.addUser(user);
  }
}
