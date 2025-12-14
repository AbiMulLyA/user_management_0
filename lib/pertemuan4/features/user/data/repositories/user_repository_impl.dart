// ============================================================================
// PERTEMUAN 4: REPOSITORY IMPLEMENTATION - DATA LAYER
// ============================================================================
//
// Implementasi dari Repository Interface yang ada di Domain Layer.
// Class ini menghubungkan Domain dengan Data Source.
//
// ============================================================================

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

/// Implementasi Repository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      final userModels = await remoteDataSource.getUsers();
      // UserModel extends UserEntity, jadi bisa langsung return
      return userModels;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<UserEntity> addUser(UserEntity user) async {
    try {
      // Convert Entity ke Model untuk dikirim ke API
      final userModel = UserModel(
        id: '',
        name: user.name,
        address: user.address,
        email: user.email,
        phoneNumber: user.phoneNumber,
        city: user.city,
      );

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
