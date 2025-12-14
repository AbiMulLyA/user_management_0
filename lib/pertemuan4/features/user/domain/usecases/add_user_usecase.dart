// ============================================================================
// PERTEMUAN 4: ADD USER USE CASE - DOMAIN LAYER
// ============================================================================

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk menambahkan user baru
class AddUserUseCase {
  final UserRepository repository;

  AddUserUseCase({required this.repository});

  /// Menjalankan use case
  Future<UserEntity> execute(UserEntity user) async {
    return await repository.addUser(user);
  }
}
