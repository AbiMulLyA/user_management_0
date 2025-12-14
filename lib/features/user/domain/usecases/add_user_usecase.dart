import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk menambahkan user baru
class AddUserUseCase {
  final UserRepository repository;

  AddUserUseCase({required this.repository});

  Future<UserEntity> execute(UserEntity user) async {
    // Validasi data sebelum mengirim ke repository
    if (user.name.isEmpty) {
      throw Exception('Nama tidak boleh kosong');
    }
    if (user.email.isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    return await repository.addUser(user);
  }
}
