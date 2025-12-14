import '../entities/city_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list kota
class GetCitiesUseCase {
  final UserRepository repository;

  GetCitiesUseCase({required this.repository});

  Future<List<CityEntity>> execute() async {
    return await repository.getCities();
  }
}
