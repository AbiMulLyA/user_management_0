import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../models/user_model.dart';

/// Implementasi konkrit dari UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      // Mendapatkan data dari remote data source
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
        id: '', // ID akan di-generate oleh API
        name: user.name,
        address: user.address,
        email: user.email,
        phoneNumber: user.phoneNumber,
        city: user.city,
      );

      // Kirim ke remote data source
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
