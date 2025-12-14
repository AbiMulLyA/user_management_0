// ============================================================================
// PERTEMUAN 4: GET CITIES USE CASE - DOMAIN LAYER
// ============================================================================

import '../entities/city_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list kota
class GetCitiesUseCase {
  final UserRepository repository;

  GetCitiesUseCase({required this.repository});

  /// Menjalankan use case
  Future<List<CityEntity>> execute() async {
    return await repository.getCities();
  }
}
