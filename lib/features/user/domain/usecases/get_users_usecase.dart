import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list user
/// Berisi business logic untuk fetch users
class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  Future<List<UserEntity>> execute() async {
    return await repository.getUsers();
  }
}
