import '../entities/user_entity.dart';
import '../entities/city_entity.dart';

/// Repository interface di domain layer
/// Tidak bergantung pada implementasi konkrit
abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> addUser(UserEntity user);
  Future<List<CityEntity>> getCities();
}
