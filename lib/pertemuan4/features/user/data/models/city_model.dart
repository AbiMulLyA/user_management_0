// ============================================================================
// PERTEMUAN 4: CITY MODEL - DATA LAYER
// ============================================================================

import '../../domain/entities/city_entity.dart';

/// Model City - extends CityEntity dengan parsing JSON
class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.name,
  });

  /// Factory method untuk parsing JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
